with mcn as (
select m.name mapping
     , comp.NAME comp_name
     , CASE comp.type_name 
         WHEN 'AGGREGATE' THEN 'A'
         WHEN 'DISTINCT' THEN 'D'
         WHEN 'FILTER' THEN 'F'
         WHEN 'JOIN' THEN 'J'
         WHEN 'LOOKUP' THEN 'L'
         WHEN 'SPLITTER' THEN 'P'
         WHEN 'REUSABLEMAPPING' THEN 'R'
         WHEN 'SET' THEN 'S'
         WHEN 'DATASTORE' THEN 'T'
         WHEN 'EXPRESSION' THEN 'X'
         ELSE comp.type_name END comp_type
     , t.table_name
     , cps.i_owner_map_comp i_cps, cpe.i_owner_map_comp i_cpe
--     , comp.i_map_ref, comp.i_owner_mapping
FROM      snp_mapping  m     
JOIN      snp_map_comp comp  ON m.i_mapping             = comp.i_owner_mapping
JOIN      snp_map_cp   cps   ON cps.i_owner_map_comp    = comp.i_map_comp and cps.direction = 'O'
LEFT JOIN snp_map_conn conn  ON cps.i_map_cp            = conn.i_start_map_cp 
LEFT JOIN snp_map_cp   cpe   ON cpe.i_map_cp            = conn.i_end_map_cp
LEFT JOIN snp_map_ref  mr    ON comp.i_map_ref          = mr.i_map_ref
LEFT JOIN snp_table    t     ON mr.i_ref_id             = t.i_table
  )
SELECT LEVEL
     , RPAD('.', (level-1)*2, '.') || comp_name AS tree
     , mcn.* 
     , ltrim(sys_connect_by_path(comp_name, '<-'), '-') AS path
FROM   mcn
WHERE  mapping LIKE 'MAP_BLABLA%'
START WITH i_cpe IS NULL
CONNECT BY i_cpe = PRIOR i_cps
ORDER BY mapping, path
