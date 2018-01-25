# update the hardcoded mapr uid and gid
find / -user 5000 -exec chown mapr {} \;
find / -group 5000 -exec chgrp mapr {} \;

# update the hardcoded streamsets uid and gid
find / -user 5001 -exec chown streamsets {} \;
find / -group 6000 -exec chgrp pwner_dev {} \;
