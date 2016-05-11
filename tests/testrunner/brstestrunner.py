#!/usr/bin/env python

""" brstestrunner.py: A Python testrunner for brstest that outputs a JUnit-compatible report.
"""

import getopt
import os
import re
import socket
import sys
import time

from utils import TestrunnerUtils, RokuUtils

verbose_mode = False
telnet_timeout = 30
roku_ip = ""
output_file = "report.xml"


def main(argv):
    try:
        opts, args = getopt.getopt(argv, "hvi:o:", ["ip=", "output="])
    except getopt.GetoptError:
        print_usage()
        sys.exit(2)

    for opt, arg in opts:
        if opt == "-h":
            print_usage()
            sys.exit()
        elif opt == "-v":
            global verbose_mode
            verbose_mode = True
        elif opt in ("-i", "--ip"):
            try:
                socket.inet_aton(arg)
            except socket.error as err:
                verbose_print("Exception thrown: "+str(err), indentation_level=1)
                TestrunnerUtils.pretty_print("ERROR: The IP Address given is not valid!",
                                             colour=TestrunnerUtils.TextDecorations.FAIL)
                sys.exit(2)
            else:
                global roku_ip
                roku_ip = arg
        elif opt in ("-o", "--output"):
            global output_file
            output_file = arg

    if roku_ip == "":
        TestrunnerUtils.pretty_print("ERROR: Missing required arguments", colour=TestrunnerUtils.TextDecorations.FAIL)
        print_usage()
        sys.exit(2)

    print_welcome()

    # If dev channel is installed, start testing
    TestrunnerUtils.pretty_print("Checking that a dev channel app is installed...",
                                 colour=TestrunnerUtils.TextDecorations.HEADER)
    if RokuUtils.RokuUtils(roku_ip).is_dev_installed():
        verbose_print("OK", 1)
        start_testing()
    else:
        TestrunnerUtils.pretty_print("ERROR: There doesn't seem to be a dev channel app installed!",
                                     colour=TestrunnerUtils.TextDecorations.FAIL)
        sys.exit(1)


def start_testing():
    roku_utils = RokuUtils.RokuUtils(roku_ip)

    TestrunnerUtils.pretty_print("Starting testing...", colour=TestrunnerUtils.TextDecorations.HEADER)

    # Go to HOME
    verbose_print("Going to Home", 1)
    roku_utils.keypress("Home")

    # Wait for device to settle
    time.sleep(1.5)

    # Launch dev channel
    verbose_print("Launching dev channel app", 1)
    roku_utils.launch_dev_channel()

    # Connect to telnet socket
    verbose_print("Reading test results from Telnet interface...", 1)

    s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    s.settimeout(telnet_timeout)

    # connect to remote host
    try:
        s.connect((roku_ip, 8085))
    except socket.error as err:
        verbose_print("Exception thrown: "+str(err), 1)
        TestrunnerUtils.pretty_print("ERROR: Unable to connect to the Telnet interface on the Roku device!",
                                     colour=TestrunnerUtils.TextDecorations.FAIL)
        sys.exit(1)

    verbose_print("Connected to host", 2)
    verbose_print("Reading Telnet output...", 2)

    listening_to_output = True
    telnet_output = []
    end_of_tests_pattern = '.*Test suite complete.*'
    start_time = time.time()

    while listening_to_output:
        try:
            # Receive data from the socket
            data = s.recv(4096)
            if not data:
                # Host has terminated the connection
                TestrunnerUtils.pretty_print("ERROR: The connection was prematurely terminated by the host.",
                                             colour=TestrunnerUtils.TextDecorations.FAIL)
                sys.exit(1)
            else:
                # Store the line
                telnet_output.append(data.decode())
                # Attempt to stop listening to output as soon as tests are complete
                clean = TestrunnerUtils.clean_raw_telnet(telnet_output)
                if len(clean) > 3 and not re.match(end_of_tests_pattern, clean[0]) and \
                        (re.match(end_of_tests_pattern, clean[-2]) or
                         re.match(end_of_tests_pattern, clean[-3])):
                    verbose_print("Detected tests have finished", 2)
                    listening_to_output = False
        except socket.timeout:
            # Socket has timed out, no more Telnet output is being received
            verbose_print("No more Telnet output to read", 2)
            listening_to_output = False
        except Exception as err:
            # Some other error has occurred
            verbose_print("Exception thrown: "+str(err), 2)
            TestrunnerUtils.pretty_print("ERROR: There was a problem with the connection.",
                                         colour=TestrunnerUtils.TextDecorations.FAIL)
            listening_to_output = False

    end_time = time.time()
    time_taken = (round(end_time - start_time, 3))
    verbose_print("Closing connection", 2)
    s.shutdown(socket.SHUT_RDWR)
    s.close()

    verbose_print("Parsing Telnet output...", 1)
    clean_telnet = TestrunnerUtils.clean_raw_telnet(telnet_output)

    # Get last result from telnet
    clean_telnet.reverse()
    test_start_idx = [i for i, item in enumerate(clean_telnet) if re.search('.*Running unit tests!.*', item)]
    if len(test_start_idx) > 0:
        last_result = clean_telnet[:test_start_idx[0]+1]
        last_result.reverse()
    else:
        TestrunnerUtils.pretty_print("ERROR: Cannot find any test results!",
                                     colour=TestrunnerUtils.TextDecorations.FAIL)
        sys.exit(1)

    # Determine results of test suite
    try:
        result_chars = last_result[2]
    except IndexError as err:
        verbose_print("Exception thrown: "+str(err), 1)
        TestrunnerUtils.pretty_print("ERROR: Cannot find any test results!",
                                     colour=TestrunnerUtils.TextDecorations.FAIL)
        sys.exit(1)

    num_of_tests = len(result_chars)
    num_of_fails = result_chars.count('F')
    num_of_errors = result_chars.count('E')
    num_of_passes = num_of_tests - (num_of_fails + num_of_errors)

    failure_dict = {}
    error_dict = {}

    test_suite_pass = False
    if num_of_passes == num_of_tests:
        test_suite_pass = True

    text_colour = TestrunnerUtils.TextDecorations.FAIL
    if test_suite_pass:
        text_colour = TestrunnerUtils.TextDecorations.OK_GREEN

    TestrunnerUtils.pretty_print("Ran "+str(num_of_tests)+" tests in "+str(time_taken)+" seconds",
                                 colour=TestrunnerUtils.TextDecorations.HEADER)
    TestrunnerUtils.pretty_print("Tests passed: "+str(num_of_passes), 1, text_colour)
    TestrunnerUtils.pretty_print("Tests failed: "+str(num_of_fails), 1, text_colour)
    TestrunnerUtils.pretty_print("Test errors:  "+str(num_of_errors), 1, text_colour)

    if test_suite_pass:
        TestrunnerUtils.pretty_print("All tests passed!", colour=TestrunnerUtils.TextDecorations.HEADER)
    else:
        if num_of_fails > 0:
            TestrunnerUtils.pretty_print("Details of failures:", colour=TestrunnerUtils.TextDecorations.HEADER)
            failures_idx = [i for i, item in enumerate(last_result) if re.search('FAIL:.*', item)]
            for failure_index in failures_idx:
                suite = os.path.basename(os.path.splitext(last_result[failure_index-1])[0])
                case = re.match('FAIL: (?P<name>\S*).*', last_result[failure_index]).group('name')
                message = last_result[failure_index+2]

                if suite not in failure_dict:
                    failure_dict[suite] = {}
                failure_dict[suite][case] = message

            for suite in failure_dict:
                TestrunnerUtils.pretty_print(suite + ":", 1)
                for case in failure_dict[suite]:
                    TestrunnerUtils.pretty_print(case + ":", 2)
                    TestrunnerUtils.pretty_print(failure_dict[suite][case], 3)

        if num_of_errors > 0:
            TestrunnerUtils.pretty_print("Details of errors:", colour=TestrunnerUtils.TextDecorations.HEADER)
            errors_idx = [i for i, item in enumerate(last_result) if re.search('ERROR:.*', item)]
            for error_index in errors_idx:
                suite = os.path.basename(os.path.splitext(last_result[error_index-1])[0])
                case = re.match('ERROR: (?P<name>\S*).*', last_result[error_index]).group('name')
                message = last_result[error_index+2]

                if suite not in error_dict:
                    error_dict[suite] = {}
                error_dict[suite][case] = message

            for suite in error_dict:
                TestrunnerUtils.pretty_print(suite + ":", 1)
                for case in error_dict[suite]:
                    TestrunnerUtils.pretty_print(case + ":", 2)
                    TestrunnerUtils.pretty_print(error_dict[suite][case], 3)

    # Publish XML report
    TestrunnerUtils.pretty_print("Publishing XML report...", colour=TestrunnerUtils.TextDecorations.HEADER)
    tree = TestrunnerUtils.create_junit_xml(num_of_tests, num_of_passes, num_of_fails, num_of_errors,
                                            failure_dict, error_dict, time_taken)
    try:
        global output_file
        abs_output = os.path.abspath(output_file)
        verbose_print("Writing to " + abs_output, 1)

        # If the given output file is missing a file extension, use .xml
        if os.path.splitext(output_file)[1] == '':
            output_file += '.xml'

        # If the given directory structure does not exist, attempt to create it
        if not os.path.exists(os.path.dirname(abs_output)):
            os.makedirs(os.path.dirname(abs_output))

        # Write the XML file
        tree.write(abs_output, encoding="UTF-8")
    except Exception as err:
        verbose_print("Exception thrown: "+str(err), 1)
        TestrunnerUtils.pretty_print("ERROR: Unable to write the test report XML file!",
                                     colour=TestrunnerUtils.TextDecorations.FAIL)
        sys.exit(1)
    else:
        TestrunnerUtils.pretty_print("Testing complete!", colour=TestrunnerUtils.TextDecorations.OK_BLUE)
        sys.exit(0)


def print_welcome():
    TestrunnerUtils.pretty_print("""
    ***********************
    ***  brstestrunner  ***
    ***********************
    """, 1, TestrunnerUtils.TextDecorations.HEADER, TestrunnerUtils.TextDecorations.BOLD)

    verbose_print("Verbose Mode is ON"+os.linesep, colour=TestrunnerUtils.TextDecorations.WARNING)


def print_usage():
    TestrunnerUtils.printout("""usage: """ + sys.argv[0] + """ --ip i [--outdir d] [--outname n] [-v] [-h]
    --ip -i       IP address of the Roku device to test with
    --output -o   The file to write the XML report to (Default is '<current directory>/report.xml')
    -v            Show more descriptive logging
    -h            Show help / usage

    Example: """ + sys.argv[0] + """ --ip 192.168.1.78 --output tests/testreport.xml -v""")


def verbose_print(string, indentation_level=0, colour="", decoration=""):
    if verbose_mode:
        TestrunnerUtils.pretty_print(string, indentation_level, colour, decoration)


if __name__ == "__main__":
    main(sys.argv[1:])
