#!/usr/bin/env python


import sys
import os
import xml.etree.ElementTree as ElementTree


def create_junit_xml(num_of_tests, num_of_passes, num_of_fails, num_of_errors, failure_dict, error_dict, time_taken):
    """Generate an ElementTree of a test report

    :param num_of_tests: Total number of tests
    :param num_of_passes: Number of passing tests
    :param num_of_fails: Number of failing tests
    :param num_of_errors: Number of erroneous tests
    :param failure_dict: Dictionary of failing tests
    :param error_dict: Dictionary of erroneous tests
    :param time_taken: Time taken to run tests, in seconds
    :return: ElementTree of the test report
    """
    # Create root element
    root = ElementTree.Element("testsuites", {"tests": str(num_of_tests), "failures": str(num_of_fails),
                                              "errors": str(num_of_errors), "time": str(time_taken)})

    # Create passing (fake) tests
    passing_suite = ElementTree.SubElement(root, "testsuite", {"name": "passing tests", "tests": str(num_of_passes)})
    for i in range(num_of_passes):
        ElementTree.SubElement(passing_suite, "testcase", {"name": "passing test #"+str(i+1)})

    # Create failing tests
    for suite in failure_dict:
        count = str(len(failure_dict[suite]))
        suite_element = ElementTree.SubElement(root, "testsuite", {"name": suite, "tests": count, "failures": count})
        for case in failure_dict[suite]:
            case_element = ElementTree.SubElement(suite_element, "testcase", {"name": case, "classname": suite})
            ElementTree.SubElement(case_element, "failure", {"message": failure_dict[suite][case]})

    # Create erroneous tests
    for suite in error_dict:
        count = str(len(error_dict[suite]))
        suite_element = ElementTree.SubElement(root, "testsuite", {"name": suite, "tests": count, "errors": count})
        for case in error_dict[suite]:
            case_element = ElementTree.SubElement(suite_element, "testcase", {"name": case, "classname": suite})
            ElementTree.SubElement(case_element, "error", {"message": error_dict[suite][case]})

    # Create tree
    tree = ElementTree.ElementTree(root)
    return tree


def clean_raw_telnet(telnet_output):
    """Clean raw telnet output from a brstest session

    :param telnet_output: List of raw (decoded) telnet lines
    :return: List of cleaned output lines, with empty lines removed
    """
    split_str = "".join(telnet_output).split("\r\n")
    while split_str.count("") > 0:
        split_str.remove("")
    return split_str


def pretty_print(string, indentation_level=0, colour="", decoration=""):
    """Print pretty text to the console
    :param string: String to print
    :param indentation_level: The number of indentation levels to apply
    :param colour: ANSI colour code to apply
    :param decoration: ANSI decoration code to apply
    """
    s = ""

    for i in range(indentation_level):
        s += "\t"

    if decoration != "":
        s += decoration
    if colour != "":
        s += colour
    s += string
    if colour != "" or decoration != "":
        s += TextDecorations.END_DECORATION
    printout(s)


def printout(string):
    """Write to stdout with line seperator
    :param string: String to print
    """
    sys.stdout.write(string + os.linesep)


class TextDecorations:
    """Constants for ANSI decoration codes
    """
    HEADER = '\033[35m'
    OK_BLUE = '\033[34m'
    OK_GREEN = '\033[32m'
    WARNING = '\033[33m'
    FAIL = '\033[31m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END_DECORATION = '\033[0m'
