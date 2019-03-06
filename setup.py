from setuptools import setup, find_packages

setup(
    name='bokehcytoscapecola',
    version='0.0.1',
    packages=find_packages(exclude=['contrib', 'docs', 'tests']),
    install_requires=['bokeh>=1.0.4'],
    url='https://github.com/lukauskas/bokeh-cytoscape-cola',
    license='MIT',
    author='Saulius Lukauskas',
    author_email='saulius.lukauskas@helmholtz-muenchen.de',
    description='',
    package_data={
        'bokehcytoscapecola': ['bokehcytoscapecola/*.coffee']
    },
    include_package_data=True,
)
