#!/bin/bash

echo "--- 221201-3 -----------------------------------------------------------"

# LDAPS copy
docker cp /home/mimi/wk/docker_wrf/TarZipFiles/LDAPS_221201-3/ wrf:/home/myuser/WRF/DATA/LDPS

# MAP copy 
docker cp /home/mimi/wk/MIMI_REF/231221_success_dobong/EGIS wrf:/home/myuser/WRF/WPS_GEOG
docker exec wrf mv /home/myuser/WRF/WPS_GEOG/EGIS/index_dobong231220 /home/myuser/WRF/WPS_GEOG/EGIS/index

# GEOGRID.TBL
docker exec wrf mv /home/myuser/WRF/WPS/geogrid/GEOGRID.TBL.ARW /home/myuser/WRF/WPS/geogrid/GEOGRID.TBL.ARW_ori
docker cp /home/mimi/wk/MIMI_REF/231221_success_dobong/GEOGRID.TBL.ARW wrf:/home/myuser/WRF/WPS/geogrid

# namelist.wps
docker exec wrf mv /home/myuser/WRF/WPS/namelist.wps /home/myuser/WRF/WPS/namelist.wps_ori
docker cp /home/mimi/wk/MIMI_REF/231221_success_dobong/namelist.wps wrf:/home/myuser/WRF/WPS

# Vtable - already..
# docker cp /home/mimi/wk/MIMI_REF/231221_success_dobong/Vtable.LDPS wrf:/home/myuser/WRF/WPS/ungrib/Variable_Tables

# namelist.input
docker exec wrf mv /home/myuser/WRF/WRF/test/em_real/namelist.input /home/myuser/WRF/WRF/test/em_real/namelist.input_ori
docker cp /home/mimi/wk/MIMI_REF/231221_success_dobong/namelist.input wrf:/home/myuser/WRF/WRF/test/em_real


# URBPARM.TBL
docker exec wrf mv /home/myuser/WRF/WRF/run/URBPARM.TBL /home/myuser/WRF/WRF/run/URBPARM.TBL_ori
docker cp /home/mimi/wk/MIMI_REF/231227_bk/WRFWRFrun_URBPARM.TBL wrf:/home/myuser/WRF/WRF/run/URBPARM.TBL

echo "------------------------------------------------------------------------"

# WPS && WRF
docker exec -it wrf /bin/bash -c "cd /home/myuser/WRF/WPS; ./link_grib.csh /home/myuser/WRF/DATA/LDPS/*gb2; ln -sf /home/myuser/WRF/WPS/ungrib/Variable_Tables/Vtable.LDPS ./Vtable; ./geogrid.exe; ./ungrib.exe; ./metgrid.exe; cd /home/myuser/WRF/WRF/test/em_real; ln -sf /home/myuser/WRF/WPS/met_em* .; ./real.exe; ./wrf.exe"

echo "------------------------------------------------------------------------"
