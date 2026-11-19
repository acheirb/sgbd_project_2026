SELECT v.reference, COUNT(emp) as emprunts, COUNT(DISTINCT emp.id_adherent) as adherents FROM velo v
LEFT JOIN emprunt emp on emp.reference = v.reference AND emp.date_heure_depart >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY v.reference;

PREPARE velo_2 (DATE) AS (
    SELECT v.reference, ROUND(SUM(emp.distance_parcourue),2) as distance_totale, ROUND(AVG(emp.distance_parcourue),2) as distance_moyenne FROM velo v
    JOIN emprunt emp on emp.reference = v.reference
    AND (emp.date_heure_depart BETWEEN $1 - INTERVAL '7 days' AND $1) 
    GROUP BY v.reference);

-- EXECUTE velo_2(CURRENT_DATE);