from setuptools import setup, find_packages

if __name__ == "__main__":
    setup(
    name="pydev_conda",
    packages=find_packages(where="src"),
    package_dir={"": "src"},
)
