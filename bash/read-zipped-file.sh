# reads file in ".zip" does stuff

for file in /root/Downloads/test/*.zip;
    do
    key="$(unzip -c $file exportDescriptor.properties | grep spaceKey | cut -c 10-)"
        mv $file /root/Downloads/test/$key.xml.zip
done
