#Setup table for simple fts query
CREATE VIRTUAL TABLE movie_overview USING fts3(
"id" INTEGER,
"name" TEXT,
"year" INTEGER,
"overview" TEXT,
"popularity" DECIMAL
);

.import movie-overview.txt movie_overview                   
                         
#base code            
SELECT COUNT(*)
FROM movie_overview
WHERE overview MATCH 'when';                      
                         
select '';               
                         
#fts example: search for "love" and "hate" close together (NEAR/7) from movie_overview             
SELECT id
FROM movie_overview
WHERE overview MATCH 'love NEAR/7 hate'  
ORDER BY id ASC;                       
--there is only one ID that meets the criteria, because there are only two overview w/ the word 'hate'