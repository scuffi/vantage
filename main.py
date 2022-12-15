import os
os.system("nim --version")
os.system("nimble --version")
os.system("choosenim --version")

from setuptools import setup
import nimporter, nim_vantage

# import vantage

# setup(
#     setup_requires = [
#         "choosenim_install",        # Optional. Auto-installs Nim compiler
#     ],
# )

nim_vantage.startAPI()