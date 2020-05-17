-- Если есть ошибки или вопросы - skype: nbvjatqswat99  обсудим:)
-- 1.	Выбрать имена и фамилии студентов, успешно сдавших экзамен, 
-- упорядоченных по результату экзамена (отличники первые в результате)
-- P.S Что значит успешно?(Выведены те, у которых оценка выше 3) Какой экзамен? (Выведены все экзамены) 

SELECT 
	first_name
    , last_name
FROM 
	student st
INNER JOIN
	student_result strs ON st.id = strs.student_id 
WHERE result > 3
ORDER BY result DESC

-- 2.	Посчитать количество студентов, успешно сдавших экзамен на 4 и 5
-- Можно написать 3 варианта: 1. Считать только студентов, которые сдали все экзамены успешно. 2. Считать студентов которые могли сдать один экзамен хорошо, а другой плохо. Тогда, например, студент, сдавший 3 экзамено положитеьно будте посчитан 3 раза. Dasha Vasilieva сдала 3 экзамена - два хорошо, один плохо. В итоге она будет посчитана два раза
-- 3. Можно считать студентов, которые сдали хотя бы один экзамен положительно. Тогда не будут посчитаны дуликаты. 
-- В общем, нужно уточнять
-- Реализован вариант в котором считаются дубликаты(положительно сданные экзамены)

SELECT
	count(id)
FROM 
	Student st
INNER JOIN 
	student_result strs ON st.id = strs.student_id 
WHERE result BETWEEN  4 AND 5

	
-- 3.	Посчитать количество студентов, сдавших экзамен “автоматом” (нет записи в таблице exam_result но есть положительный результат в таблице student_result) 
-- Здесь ситуация аналогична
SELECT
	count(*)
FROM
	student_result
WHERE exam_id IS NULL;

-- 4.	Посчитать средний балл студентов по предмету с наименованием “Системы управления базами данных” 
SELECT
	AVG(result)
FROM 
	student_result sr
JOIN 
	training_course tc ON sr.training_course_id = tc.id
WHERE name = "RDBMS"


-- 5.	Выбрать имена и фамилии студентов, не сдававших экзамен по предмету “Теория графов” (2 вида запроса)
-- Есть только Math, но Math никто не учит ¯\_(ツ)_/¯
SELECT 
	first_name
    , last_name
FROM 
	student_result sr
JOIN training_course tc ON sr.training_course_id = tc.id
JOIN student s ON  sr.student_id = s.id
WHERE name = "RDBMS" AND result < 3

-- 2 вариант
SELECT 
	first_name
    , last_name
FROM 
	student_result sr
    , training_course tc
    , student s 
WHERE sr.training_course_id = tc.id
	AND sr.student_id = s.id
	AND name = "RDBMS" 
	AND result < 3


-- 6.	Выбрать идентификатор преподавателей, читающих лекции по больше чем 2-ум предметам
-- > 1. >2 нет.
SELECT
	teacher_id
FROM 
	training_course
GROUP BY 
	teacher_id
HAVING count(*) > 1


-- 7.	Выбрать идентификатор и фамилии студентов, пересдававших хотя бы 1 предмет (2 и более записи в exam_result)
SELECT
	student_id
    , last_name
FROM 
	exam_result er
JOIN student s ON
	s.id = er.student_id
GROUP BY 
     teacher_id
    , student_id
    , exam_id
HAVING count(*) > 1
    
-- 8.	Вывести имена и фамилии 5 студентов с максимальными оценками
SELECT 
	first_name
    , last_name
FROM 
	student_result sr
JOIN student s ON
	s.id = sr.student_id
ORDER BY result DESC
LIMIT 5


-- 9.	Вывести фамилию преподавателя, у которого наилучшие результаты по его предметам
SELECT
	last_name,
    MAX(result)
FROM
(
	SELECT
		 last_name
		, AVG(result) result
	FROM 
		student_result sr
	JOIN 
		training_course tc ON sr.training_course_id = tc.id
	JOIN techer t ON tc.teacher_id = t.id 
	GROUP BY training_course_id
	ORDER BY result DESC
) a


-- 10.	Вывести успеваемость студентов по годам по предмету “Математическая статистика”
-- Math никто не учит ¯\_(ツ)_/¯, поэтому будет RDBMS
SELECT 
	name
    , AVG(result) avg_mark
    , YEAR(date) year
FROM 
	student_result sr
JOIN 
	training_course tc ON sr.training_course_id = tc.id
WHERE name = "RDBMS"
GROUP BY year



-- Скрипт проверяет соответствие строк в таблицах exam_result и student_result
SELECT 
	*
FROM 
	student_result sr
RIGHT JOIN -- LEFTJOIN
	exam_result er ON 
		sr.exam_id = er.exam_id
        AND sr.student_id = er.student_id
WHERE sr.exam_id IS NOT NULL