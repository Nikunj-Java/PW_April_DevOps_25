from math_utils import multiply

def test_multiply():
    assert multiply(3,5) == 15
    assert multiply(0,10) == 0
    assert multiply(-2,3) == -6