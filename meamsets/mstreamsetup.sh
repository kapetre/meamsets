# update the hardcoded mapr uid and gid
find / -user 1005 -exec chown mapr {} \;
find / -group 1005 -exec chgrp mapr {} \;

# update the hardcoded streamsets uid and gid
find / -user 1475200018 -exec chown streamsets {} \;
find / -group 1475200006 -exec chgrp pwner_dev {} \;
