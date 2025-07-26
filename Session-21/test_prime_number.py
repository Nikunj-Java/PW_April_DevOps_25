from prime_number import is_prime

def test_is_prime():
    assert is_prime(2)
    assert is_prime(13)

    assert is_prime(7)
    assert is_prime(11)
    assert is_prime(13)
    assert is_prime(17)
    assert is_prime(19)
    assert is_prime(23)