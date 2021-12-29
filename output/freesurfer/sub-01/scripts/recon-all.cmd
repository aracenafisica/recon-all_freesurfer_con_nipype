

#---------------------------------
# New invocation of recon-all lun 27 dic 2021 16:32:28 -03 

 mri_convert /opt/home/aracena/thesis_practica/data/ds002422/sub-01/anat/sub-01_T1w.nii /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor lun 27 dic 2021 16:32:34 -03

 cp /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/orig/001.mgz /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/rawavg.mgz 


 mri_convert /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/rawavg.mgz /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/transforms/talairach.xfm /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/orig.mgz /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/orig.mgz 

#--------------------------------------------
#@# Talairach lun 27 dic 2021 16:32:43 -03

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --ants-n4 --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

lta_convert --src orig.mgz --trg /home/aracena/freesurfer/average/mni305.cor.mgz --inxfm transforms/talairach.xfm --outlta transforms/talairach.xfm.lta --subject fsaverage --ltavox2vox
#--------------------------------------------
#@# Talairach Failure Detection lun 27 dic 2021 16:36:21 -03

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /home/aracena/freesurfer/bin/extract_talairach_avi_QA.awk /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/transforms/talairach_avi.log 


 tal_QC_AZS /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction lun 27 dic 2021 16:36:21 -03

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 --ants-n4 


 mri_add_xform_to_header -c /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization lun 27 dic 2021 16:39:47 -03

 mri_normalize -g 1 -seed 1234 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping lun 27 dic 2021 16:41:42 -03

 mri_em_register -skull nu.mgz /home/aracena/freesurfer/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta 


 mri_watershed -T1 -brain_atlas /home/aracena/freesurfer/average/RB_all_withskull_2020_01_02.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration lun 27 dic 2021 16:51:03 -03

 mri_em_register -uns 3 -mask brainmask.mgz nu.mgz /home/aracena/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize lun 27 dic 2021 16:59:23 -03

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /home/aracena/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg lun 27 dic 2021 17:00:37 -03

 mri_ca_register -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /home/aracena/freesurfer/average/RB_all_2020-01-02.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg lun 27 dic 2021 19:26:33 -03

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /home/aracena/freesurfer/average/RB_all_2020-01-02.gca aseg.auto_noCCseg.mgz 

#--------------------------------------
#@# CC Seg lun 27 dic 2021 20:08:10 -03

 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/transforms/cc_up.lta sub-01 

#--------------------------------------
#@# Merge ASeg lun 27 dic 2021 20:08:49 -03

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 lun 27 dic 2021 20:08:49 -03

 mri_normalize -seed 1234 -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS lun 27 dic 2021 20:11:41 -03

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation lun 27 dic 2021 20:11:43 -03

 AntsDenoiseImageFs -i brain.mgz -o antsdn.brain.mgz 


 mri_segment -wsizemm 13 -mprage antsdn.brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill lun 27 dic 2021 20:14:29 -03

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.presurf.mgz -ctab /home/aracena/freesurfer/SubCorticalMassLUT.txt wm.mgz filled.mgz 

 cp filled.mgz filled.auto.mgz
#--------------------------------------------
#@# Tessellate lh lun 27 dic 2021 20:15:33 -03

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh lun 27 dic 2021 20:15:38 -03

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh lun 27 dic 2021 20:15:42 -03

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh lun 27 dic 2021 20:15:45 -03

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh lun 27 dic 2021 20:15:48 -03

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh lun 27 dic 2021 20:16:08 -03

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh lun 27 dic 2021 20:16:27 -03

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh lun 27 dic 2021 20:19:03 -03

 mris_sphere -q -p 6 -a 128 -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#@# Fix Topology lh lun 27 dic 2021 20:22:18 -03

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub-01 lh 

#@# Fix Topology rh lun 27 dic 2021 20:23:41 -03

 mris_fix_topology -mgz -sphere qsphere.nofix -inflated inflated.nofix -orig orig.nofix -out orig.premesh -ga -seed 1234 sub-01 rh 


 mris_euler_number ../surf/lh.orig.premesh 


 mris_euler_number ../surf/rh.orig.premesh 


 mris_remesh --remesh --iters 3 --input /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.orig.premesh --output /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.orig 


 mris_remesh --remesh --iters 3 --input /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.orig.premesh --output /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm -f ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm -f ../surf/rh.inflated 

#--------------------------------------------
#@# AutoDetGWStats lh lun 27 dic 2021 20:25:36 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.lh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/lh.orig.premesh
#--------------------------------------------
#@# AutoDetGWStats rh lun 27 dic 2021 20:25:40 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_autodet_gwstats --o ../surf/autodet.gw.stats.rh.dat --i brain.finalsurfs.mgz --wm wm.mgz --surf ../surf/rh.orig.premesh
#--------------------------------------------
#@# WhitePreAparc lh lun 27 dic 2021 20:25:45 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --wm wm.mgz --threads 1 --invol brain.finalsurfs.mgz --lh --i ../surf/lh.orig --o ../surf/lh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# WhitePreAparc rh lun 27 dic 2021 20:29:15 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --wm wm.mgz --threads 1 --invol brain.finalsurfs.mgz --rh --i ../surf/rh.orig --o ../surf/rh.white.preaparc --white --seg aseg.presurf.mgz --nsmooth 5
#--------------------------------------------
#@# CortexLabel lh lun 27 dic 2021 20:33:20 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 0 ../label/lh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg lh lun 27 dic 2021 20:33:37 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mri_label2label --label-cortex ../surf/lh.white.preaparc aseg.presurf.mgz 1 ../label/lh.cortex+hipamyg.label
#--------------------------------------------
#@# CortexLabel rh lun 27 dic 2021 20:33:54 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 0 ../label/rh.cortex.label
#--------------------------------------------
#@# CortexLabel+HipAmyg rh lun 27 dic 2021 20:34:13 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mri_label2label --label-cortex ../surf/rh.white.preaparc aseg.presurf.mgz 1 ../label/rh.cortex+hipamyg.label
#--------------------------------------------
#@# Smooth2 lh lun 27 dic 2021 20:34:32 -03

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh lun 27 dic 2021 20:34:36 -03

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh lun 27 dic 2021 20:34:40 -03

 mris_inflate ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh lun 27 dic 2021 20:35:11 -03

 mris_inflate ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh lun 27 dic 2021 20:35:43 -03

 mris_curvature -w -seed 1234 lh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh lun 27 dic 2021 20:36:34 -03

 mris_curvature -w -seed 1234 rh.white.preaparc 


 mris_curvature -seed 1234 -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 

#--------------------------------------------
#@# Sphere lh lun 27 dic 2021 20:37:25 -03

 mris_sphere -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh lun 27 dic 2021 20:45:34 -03

 mris_sphere -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh lun 27 dic 2021 20:50:00 -03

 mris_register -curv ../surf/lh.sphere /home/aracena/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 


 ln -sf lh.sphere.reg lh.fsaverage.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh lun 27 dic 2021 20:57:39 -03

 mris_register -curv ../surf/rh.sphere /home/aracena/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 


 ln -sf rh.sphere.reg rh.fsaverage.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh lun 27 dic 2021 21:06:31 -03

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh lun 27 dic 2021 21:06:32 -03

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh lun 27 dic 2021 21:06:34 -03

 mrisp_paint -a 5 /home/aracena/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh lun 27 dic 2021 21:06:35 -03

 mrisp_paint -a 5 /home/aracena/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh lun 27 dic 2021 21:06:36 -03

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /home/aracena/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh lun 27 dic 2021 21:06:47 -03

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /home/aracena/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# WhiteSurfs lh lun 27 dic 2021 21:06:58 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white.preaparc --o ../surf/lh.white --white --nsmooth 0 --rip-label ../label/lh.cortex.label --rip-bg --rip-surf ../surf/lh.white.preaparc --aparc ../label/lh.aparc.annot
#--------------------------------------------
#@# WhiteSurfs rh lun 27 dic 2021 21:10:22 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white.preaparc --o ../surf/rh.white --white --nsmooth 0 --rip-label ../label/rh.cortex.label --rip-bg --rip-surf ../surf/rh.white.preaparc --aparc ../label/rh.aparc.annot
#--------------------------------------------
#@# T1PialSurf lh lun 27 dic 2021 21:14:00 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.lh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --lh --i ../surf/lh.white --o ../surf/lh.pial.T1 --pial --nsmooth 0 --rip-label ../label/lh.cortex+hipamyg.label --pin-medial-wall ../label/lh.cortex.label --aparc ../label/lh.aparc.annot --repulse-surf ../surf/lh.white --white-surf ../surf/lh.white
#--------------------------------------------
#@# T1PialSurf rh lun 27 dic 2021 21:17:54 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --adgws-in ../surf/autodet.gw.stats.rh.dat --seg aseg.presurf.mgz --threads 1 --wm wm.mgz --invol brain.finalsurfs.mgz --rh --i ../surf/rh.white --o ../surf/rh.pial.T1 --pial --nsmooth 0 --rip-label ../label/rh.cortex+hipamyg.label --pin-medial-wall ../label/rh.cortex.label --aparc ../label/rh.aparc.annot --repulse-surf ../surf/rh.white --white-surf ../surf/rh.white
#@# white curv lh lun 27 dic 2021 21:21:55 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --curv-map ../surf/lh.white 2 10 ../surf/lh.curv
#@# white area lh lun 27 dic 2021 21:21:57 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --area-map ../surf/lh.white ../surf/lh.area
#@# pial curv lh lun 27 dic 2021 21:21:58 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --curv-map ../surf/lh.pial 2 10 ../surf/lh.curv.pial
#@# pial area lh lun 27 dic 2021 21:22:01 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --area-map ../surf/lh.pial ../surf/lh.area.pial
#@# thickness lh lun 27 dic 2021 21:22:02 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# area and vertex vol lh lun 27 dic 2021 21:22:42 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --thickness ../surf/lh.white ../surf/lh.pial 20 5 ../surf/lh.thickness
#@# white curv rh lun 27 dic 2021 21:22:44 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --curv-map ../surf/rh.white 2 10 ../surf/rh.curv
#@# white area rh lun 27 dic 2021 21:22:47 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --area-map ../surf/rh.white ../surf/rh.area
#@# pial curv rh lun 27 dic 2021 21:22:48 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --curv-map ../surf/rh.pial 2 10 ../surf/rh.curv.pial
#@# pial area rh lun 27 dic 2021 21:22:50 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --area-map ../surf/rh.pial ../surf/rh.area.pial
#@# thickness rh lun 27 dic 2021 21:22:51 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness
#@# area and vertex vol rh lun 27 dic 2021 21:23:33 -03
cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri
mris_place_surface --thickness ../surf/rh.white ../surf/rh.pial 20 5 ../surf/rh.thickness

#-----------------------------------------
#@# Curvature Stats lh lun 27 dic 2021 21:23:35 -03

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-01 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh lun 27 dic 2021 21:23:38 -03

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-01 rh curv sulc 

#--------------------------------------------
#@# Cortical ribbon mask lun 27 dic 2021 21:23:41 -03

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-01 

#-----------------------------------------
#@# Cortical Parc 2 lh lun 27 dic 2021 21:31:43 -03

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /home/aracena/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh lun 27 dic 2021 21:31:58 -03

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /home/aracena/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 3 lh lun 27 dic 2021 21:32:14 -03

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /home/aracena/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh lun 27 dic 2021 21:32:25 -03

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /home/aracena/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# WM/GM Contrast lh lun 27 dic 2021 21:32:38 -03

 pctsurfcon --s sub-01 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh lun 27 dic 2021 21:32:42 -03

 pctsurfcon --s sub-01 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities lun 27 dic 2021 21:32:46 -03

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# APas-to-ASeg lun 27 dic 2021 21:33:04 -03

 mri_surf2volseg --o aseg.mgz --i aseg.presurf.hypos.mgz --fix-presurf-with-ribbon /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/mri/ribbon.mgz --threads 1 --lh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.cortex.label --lh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.white --lh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.pial --rh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.cortex.label --rh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.white --rh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.pial 


 mri_brainvol_stats sub-01 

#-----------------------------------------
#@# AParc-to-ASeg aparc lun 27 dic 2021 21:33:19 -03

 mri_surf2volseg --o aparc+aseg.mgz --label-cortex --i aseg.mgz --threads 1 --lh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.aparc.annot 1000 --lh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.cortex.label --lh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.white --lh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.pial --rh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.aparc.annot 2000 --rh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.cortex.label --rh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.white --rh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.a2009s lun 27 dic 2021 21:36:44 -03

 mri_surf2volseg --o aparc.a2009s+aseg.mgz --label-cortex --i aseg.mgz --threads 1 --lh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.aparc.a2009s.annot 11100 --lh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.cortex.label --lh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.white --lh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.pial --rh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.aparc.a2009s.annot 12100 --rh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.cortex.label --rh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.white --rh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.pial 

#-----------------------------------------
#@# AParc-to-ASeg aparc.DKTatlas lun 27 dic 2021 21:40:09 -03

 mri_surf2volseg --o aparc.DKTatlas+aseg.mgz --label-cortex --i aseg.mgz --threads 1 --lh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.aparc.DKTatlas.annot 1000 --lh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.cortex.label --lh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.white --lh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.pial --rh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.aparc.DKTatlas.annot 2000 --rh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.cortex.label --rh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.white --rh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.pial 

#-----------------------------------------
#@# WMParc lun 27 dic 2021 21:43:33 -03

 mri_surf2volseg --o wmparc.mgz --label-wm --i aparc+aseg.mgz --threads 1 --lh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.aparc.annot 3000 --lh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/lh.cortex.label --lh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.white --lh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/lh.pial --rh-annot /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.aparc.annot 4000 --rh-cortex-mask /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/label/rh.cortex.label --rh-white /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.white --rh-pial /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/sub-01/surf/rh.pial 


 mri_segstats --seed 1234 --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-01 --surf-wm-vol --ctab /home/aracena/freesurfer/WMParcStatsLUT.txt --etiv 

#-----------------------------------------
#@# Parcellation Stats lh lun 27 dic 2021 21:50:08 -03

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh lun 27 dic 2021 21:50:37 -03

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh pial 

#-----------------------------------------
#@# Parcellation Stats 2 lh lun 27 dic 2021 21:51:08 -03

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh lun 27 dic 2021 21:51:24 -03

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 rh white 

#-----------------------------------------
#@# Parcellation Stats 3 lh lun 27 dic 2021 21:51:40 -03

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh lun 27 dic 2021 21:51:55 -03

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 rh white 

#--------------------------------------------
#@# ASeg Stats lun 27 dic 2021 21:52:10 -03

 mri_segstats --seed 1234 --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /home/aracena/freesurfer/ASegStatsLUT.txt --subject sub-01 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer; ln -s /home/aracena/freesurfer/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh lun 27 dic 2021 21:55:04 -03

 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.FG1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.FG2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.FG3.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG3.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.FG4.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.FG4.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.hOc1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc1.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.hOc2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc2.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.hOc3v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc3v.mpm.vpnl.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.hOc4v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./lh.hOc4v.mpm.vpnl.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --ctab /home/aracena/freesurfer/average/colortable_vpnl.txt --hemi lh --a mpm.vpnl --maxstatwinner --noverbose --l lh.FG1.mpm.vpnl.label --l lh.FG2.mpm.vpnl.label --l lh.FG3.mpm.vpnl.label --l lh.FG4.mpm.vpnl.label --l lh.hOc1.mpm.vpnl.label --l lh.hOc2.mpm.vpnl.label --l lh.hOc3v.mpm.vpnl.label --l lh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --hemi lh --ctab /home/aracena/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.perirhinal_exvivo.label --l lh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi lh --ctab /home/aracena/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh lun 27 dic 2021 21:59:18 -03

 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.FG1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.FG2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.FG3.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG3.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.FG4.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.FG4.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.hOc1.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc1.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.hOc2.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc2.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.hOc3v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc3v.mpm.vpnl.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.hOc4v.mpm.vpnl.label --trgsubject sub-01 --trglabel ./rh.hOc4v.mpm.vpnl.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --ctab /home/aracena/freesurfer/average/colortable_vpnl.txt --hemi rh --a mpm.vpnl --maxstatwinner --noverbose --l rh.FG1.mpm.vpnl.label --l rh.FG2.mpm.vpnl.label --l rh.FG3.mpm.vpnl.label --l rh.FG4.mpm.vpnl.label --l rh.hOc1.mpm.vpnl.label --l rh.hOc2.mpm.vpnl.label --l rh.hOc3v.mpm.vpnl.label --l rh.hOc4v.mpm.vpnl.label 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /opt/home/aracena/thesis_practica/tips_nibabel/3_recon-all_freesurfer/output/freesurfer/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --hemi rh --ctab /home/aracena/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.perirhinal_exvivo.label --l rh.entorhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi rh --ctab /home/aracena/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 rh white 

