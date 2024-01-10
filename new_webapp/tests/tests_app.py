import unittest
from flask import Flask
from app import app

class TestHomeRoute(unittest.TestCase):
  def setUp(self):
    self.app = app.test_client()
    self.app.testing = True

  def test_home_status_code(self):
    response = self.app.get('/')
    self.assertEqual(response.status_code, 200)

  def test_home_data(self):
    response = self.app.get('/')
    self.assertIn(b'Welcome to my web app', response.data)

if __name__ == '__main__':
  unittest.main()