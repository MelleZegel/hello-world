WITH mcn AS (
SELECT m.NAME mapping, cpe.name to_cp, cps.name from_cp
     , comp.NAME comp_name
     , comp.type_name comp_type
     , t.table_name
     , cps.i_owner_map_comp i_cps, cpe.i_owner_map_comp i_cpe
     , comp.i_map_ref, comp.i_owner_mapping
FROM      snp_mapping  m     
JOIN      snp_map_comp comp  ON m.i_mapping             = comp.i_owner_mapping
JOIN      snp_map_cp   cps   ON cps.i_owner_map_comp    = comp.i_map_comp and cps.direction = 'O'
LEFT JOIN snp_map_conn conn  ON cps.i_map_cp            = conn.i_start_map_cp 
LEFT JOIN snp_map_cp   cpe   ON cpe.i_map_cp            = conn.i_end_map_cp
LEFT JOIN snp_map_ref  mr    ON comp.i_map_ref          = mr.i_map_ref
LEFT JOIN snp_table    t     ON mr.i_ref_id             = t.i_table
  )
, flw AS (
SELECT mcn.mapping
     , rpad('.', (LEVEL-1)*2, '.') || comp_name AS flow
     , mcn.comp_type, table_name, mcn.to_cp, mcn.from_cp
     , LEVEL steps, ltrim(sys_connect_by_path(comp_name, '<-'), '-') AS impact
     , comp_name
FROM   mcn START WITH i_cpe IS NULL CONNECT BY i_cpe = PRIOR i_cps
  )
SELECT *
FROM flw
WHERE  MAPPING LIKE 'MAP_BLABLA%'
--AND    (impact LIKE '%<-ORG<-%' OR comp_name = 'ORG')
--AND steps < 13
ORDER BY MAPPING, impact
;
