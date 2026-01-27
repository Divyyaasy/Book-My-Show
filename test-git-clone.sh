#!/bin/bash
echo "Testing Git access from Jenkins workspace..."
cd /tmp
rm -rf test-clone
git clone https://github.com/staragile2016/Book-My-Show.git test-clone
if [ $? -eq 0 ]; then
    echo "✅ Git clone successful!"
    echo "Files in repository:"
    ls -la test-clone/
else
    echo "❌ Git clone failed!"
fi
