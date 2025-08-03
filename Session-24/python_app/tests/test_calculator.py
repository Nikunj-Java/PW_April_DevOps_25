import pytest
from app.calculator import add,subtract,divide,multiply

def test_add():
    assert add(2,3) == 5
def test_subtract():
    assert subtract(10,2) == 8
def test_divide():
    assert divide(20,10) == 2
def test_multiply():
    assert multiply(3,9)==27
def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10,0)
