def test_facebook_title():
    from facebook import get_facebook_title
    assert "Facebook – log in or sign up" in get_facebook_title()