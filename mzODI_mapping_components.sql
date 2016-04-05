
--------------------------------------------------------------------------------
-- ODI 12.1.3 Work repository
--
-- Select mappings with components
--
--------------------------------------------------------------------------------
WITH mc AS (
SELECT    mc.i_map_comp, mc.NAME mc_name, mc.type_name mc_type_name, mc.i_owner_mapping, mc.i_map_comp_type, t.table_name
FROM      snp_map_comp mc
LEFT JOIN snp_map_ref  mr     ON mc.i_map_ref = mr.i_map_ref
LEFT JOIN snp_table    t      ON mr.i_ref_id  = t.i_table
  )
SELECT    mpg.NAME, mc_m.i_map_comp, mc_m.mc_name, mc_m.mc_type_name, mc_m.table_name
,         CASE WHEN  mc_m.mc_type_name = 'DATASTORE' AND mcp.direction = 'O' THEN 'Source'
               WHEN  mc_m.mc_type_name = 'DATASTORE' AND mcp.direction = 'I' THEN 'Target' END src_tgt
,         mcp.direction, mcp.name mcp_name
,         mci.mc_name in_comp_name,  mci.table_name in_table_name
,         mco.mc_name out_comp_name, mco.table_name out_table_name
,         fdr.folder_name
FROM      snp_folder   fdr
JOIN      snp_mapping  mpg    ON fdr.i_folder                   = mpg.i_folder
JOIN      mc                        mc_m   ON mpg.i_mapping                  = mc_m.i_owner_mapping 
JOIN      snp_map_cp   mcp    ON mc_m.i_map_comp                = mcp.i_owner_map_comp
LEFT JOIN snp_map_conn mcni   ON mcp.i_map_cp                   = mcni.i_end_map_cp 
LEFT JOIN snp_map_cp   mcpi   ON mcpi.i_map_cp                  = mcni.i_start_map_cp
LEFT JOIN mc                        mci    ON mci.i_map_comp                 = mcpi.i_owner_map_comp 
LEFT JOIN snp_map_conn mcno   ON mcp.i_map_cp                   = mcno.i_start_map_cp 
LEFT JOIN snp_map_cp   mcpo   ON mcpo.i_map_cp                  = mcno.i_end_map_cp
LEFT JOIN mc                        mco    ON mco.i_map_comp                 = mcpo.i_owner_map_comp 
WHERE     ((mcp.direction = 'O' AND mcno.i_start_map_cp IS NOT NULL) OR (mcp.direction = 'I' AND mcni.i_end_map_cp IS NOT NULL))
--AND       mpg.NAME       LIKE 'EDW_MAP_S%'
--AND       mci.table_name LIKE 'EDW_DOT_L%'
--AND       mc_m.mc_type_name = 'DATASTORE' 
ORDER BY  mpg.NAME, mc_m.i_map_comp, mcp.direction, mcp.name
;

    Status API Training Shop Blog About 

    © 2016 GitHub, Inc. Terms Privacy Security Contact Help 

