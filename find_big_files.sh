#!/bin/bash

find . -size +40M -exec ls {} \+ >.gitignore
