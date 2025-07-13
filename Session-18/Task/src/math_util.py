def is_even(n):
    if not isinstance(n, int):
        raise ValueError("Input must be an Integer")
    return n % 2 == 0