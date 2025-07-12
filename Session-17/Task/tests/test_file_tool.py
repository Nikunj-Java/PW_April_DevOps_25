import os
from cli.file_tool import count_lines, word_frequency

def test_count_lines():
    assert count_lines("test_input.txt") == 3

def test_word_frequency():
    freq = word_frequency("test_input.txt")
    assert freq["hello"] == 2
    assert freq["world"] == 1
