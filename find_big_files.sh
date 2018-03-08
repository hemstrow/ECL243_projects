#!/bin/bash

find . -size +40M -exec ls {} \+ | grep -v ".git/" - >.gitignore
