import unittest
from src.math_util import is_even

class TestIsEvent(unittest.TestCase):
    def test_even_number(self):
        self.assertTrue(is_even(4))
  
    def test_zero(self):
        self.assertTrue(is_even(0))
    def test_invalid_type(self):
        with self.assertRaises(ValueError):
            is_even("two")
if __name__=="__main__":
    unittest.main()