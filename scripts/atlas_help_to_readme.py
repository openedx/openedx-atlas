"""
Updates the `atlas --help` section of the README.rst file.
"""

import re
import subprocess
import textwrap  # Available in Python 3.3+


with open('README.rst', encoding='utf-8') as readme_file_r:
    readme = readme_file_r.read()
    help_message = subprocess.check_output(['./atlas', '--help']).decode('utf-8')
    help_message_indented = textwrap.indent(help_message, '    ')  # Ensure it appears as a code-block in the README

    updated_readme = re.sub(
        r' {4}Atlas is a CLI tool that has essentially.*Running Automated Tests Locally',
        '{msg}\nRunning Automated Tests Locally'.format(msg=help_message_indented),
        readme,
        flags=re.DOTALL,
    )

with open('README.rst', 'w', encoding='utf-8') as readme_file_w:
    readme_file_w.write(updated_readme)
