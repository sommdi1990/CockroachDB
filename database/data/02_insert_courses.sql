-- University Management System - Sample Courses Data
-- Created for CockroachDB
-- این فایل شامل داده‌های نمونه برای دروس دانشگاه است

USE university_management;

-- =============================================
-- INSERT COURSES DATA
-- =============================================

-- دروس دانشکده مهندسی کامپیوتر
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'CS101',
    'Introduction to Programming',
    'Basic programming concepts using Python and Java',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '[]'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'CS102',
    'Data Structures and Algorithms',
    'Fundamental data structures and algorithm design',
    4,
    d.department_id,
    'Core',
    'Spring',
    2024,
    35,
    '["CS101"]'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'CS201',
    'Database Systems',
    'Database design, SQL, and database management systems',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    30,
    '["CS102"]'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'CS301',
    'Software Engineering',
    'Software development lifecycle and project management',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    25,
    '["CS201"]'
FROM departments d WHERE d.department_code = 'CE';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'CS401',
    'Machine Learning',
    'Introduction to machine learning algorithms and applications',
    3,
    d.department_id,
    'Elective',
    'Fall',
    2024,
    20,
    '["CS102", "MATH201"]'
FROM departments d WHERE d.department_code = 'CE';

-- دروس دانشکده مهندسی برق
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'EE101',
    'Circuit Analysis',
    'Basic electrical circuit analysis and theorems',
    4,
    d.department_id,
    'Core',
    'Fall',
    2024,
    35,
    '[]'
FROM departments d WHERE d.department_code = 'EE';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'EE201',
    'Digital Electronics',
    'Digital logic design and electronic circuits',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    30,
    '["EE101"]'
FROM departments d WHERE d.department_code = 'EE';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'EE301',
    'Power Systems',
    'Power generation, transmission, and distribution',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    25,
    '["EE201"]'
FROM departments d WHERE d.department_code = 'EE';

-- دروس دانشکده مهندسی مکانیک
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ME101',
    'Statics',
    'Static equilibrium and force analysis',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '[]'
FROM departments d WHERE d.department_code = 'ME';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ME201',
    'Dynamics',
    'Kinematics and kinetics of particles and rigid bodies',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    35,
    '["ME101"]'
FROM departments d WHERE d.department_code = 'ME';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ME301',
    'Thermodynamics',
    'Heat transfer and energy conversion',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    30,
    '["ME201"]'
FROM departments d WHERE d.department_code = 'ME';

-- دروس دانشکده علوم پایه
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'MATH101',
    'Calculus I',
    'Differential and integral calculus',
    4,
    d.department_id,
    'Core',
    'Fall',
    2024,
    50,
    '[]'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'MATH102',
    'Calculus II',
    'Advanced calculus and series',
    4,
    d.department_id,
    'Core',
    'Spring',
    2024,
    45,
    '["MATH101"]'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'MATH201',
    'Linear Algebra',
    'Vector spaces, matrices, and linear transformations',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '["MATH102"]'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'PHY101',
    'Physics I',
    'Mechanics, waves, and thermodynamics',
    4,
    d.department_id,
    'Core',
    'Fall',
    2024,
    45,
    '[]'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'PHY102',
    'Physics II',
    'Electricity, magnetism, and optics',
    4,
    d.department_id,
    'Core',
    'Spring',
    2024,
    40,
    '["PHY101"]'
FROM departments d WHERE d.department_code = 'BS';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'CHEM101',
    'General Chemistry',
    'Atomic structure, chemical bonding, and reactions',
    4,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '[]'
FROM departments d WHERE d.department_code = 'BS';

-- دروس دانشکده مدیریت و اقتصاد
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'BA101',
    'Principles of Management',
    'Fundamental management concepts and practices',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    50,
    '[]'
FROM departments d WHERE d.department_code = 'ME';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'BA201',
    'Marketing',
    'Marketing strategies and consumer behavior',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    45,
    '["BA101"]'
FROM departments d WHERE d.department_code = 'ME';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ECON101',
    'Microeconomics',
    'Individual and firm economic behavior',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '[]'
FROM departments d WHERE d.department_code = 'ME';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ECON102',
    'Macroeconomics',
    'National economy and economic policies',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    35,
    '["ECON101"]'
FROM departments d WHERE d.department_code = 'ME';

-- دروس دانشکده علوم انسانی
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ENG101',
    'English Composition',
    'Academic writing and communication skills',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    30,
    '[]'
FROM departments d WHERE d.department_code = 'HU';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ENG201',
    'World Literature',
    'Survey of world literature from ancient to modern times',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    25,
    '["ENG101"]'
FROM departments d WHERE d.department_code = 'HU';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'PSY101',
    'Introduction to Psychology',
    'Basic psychological concepts and theories',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '[]'
FROM departments d WHERE d.department_code = 'HU';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'PSY201',
    'Developmental Psychology',
    'Human development across the lifespan',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    35,
    '["PSY101"]'
FROM departments d WHERE d.department_code = 'HU';

-- دروس دانشکده پزشکی
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'MED101',
    'Human Anatomy',
    'Structure and organization of the human body',
    4,
    d.department_id,
    'Core',
    'Fall',
    2024,
    30,
    '[]'
FROM departments d WHERE d.department_code = 'MD';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'MED201',
    'Physiology',
    'Function of human body systems',
    4,
    d.department_id,
    'Core',
    'Spring',
    2024,
    25,
    '["MED101"]'
FROM departments d WHERE d.department_code = 'MD';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'MED301',
    'Pathology',
    'Study of disease processes and mechanisms',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    20,
    '["MED201"]'
FROM departments d WHERE d.department_code = 'MD';

-- دروس دانشکده حقوق
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'LAW101',
    'Introduction to Law',
    'Basic legal concepts and legal system',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    40,
    '[]'
FROM departments d WHERE d.department_code = 'LW';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'LAW201',
    'Constitutional Law',
    'Constitutional principles and government structure',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    35,
    '["LAW101"]'
FROM departments d WHERE d.department_code = 'LW';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'LAW301',
    'Criminal Law',
    'Criminal justice system and procedures',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    30,
    '["LAW201"]'
FROM departments d WHERE d.department_code = 'LW';

-- دروس دانشکده هنر
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ART101',
    'Drawing Fundamentals',
    'Basic drawing techniques and principles',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    25,
    '[]'
FROM departments d WHERE d.department_code = 'AR';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ART201',
    'Painting',
    'Painting techniques and color theory',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    20,
    '["ART101"]'
FROM departments d WHERE d.department_code = 'AR';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'ART301',
    'Sculpture',
    'Three-dimensional art and sculpture techniques',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    15,
    '["ART201"]'
FROM departments d WHERE d.department_code = 'AR';

-- دروس دانشکده کشاورزی
INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'AG101',
    'Plant Science',
    'Basic plant biology and agricultural applications',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    30,
    '[]'
FROM departments d WHERE d.department_code = 'AG';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'AG201',
    'Soil Science',
    'Soil properties and agricultural management',
    3,
    d.department_id,
    'Core',
    'Spring',
    2024,
    25,
    '["AG101"]'
FROM departments d WHERE d.department_code = 'AG';

INSERT INTO courses (course_id, course_code, course_name, course_description, credits, department_id, course_type, semester, academic_year, max_students, prerequisites) 
SELECT 
    gen_random_uuid(),
    'AG301',
    'Crop Production',
    'Agricultural crop production and management',
    3,
    d.department_id,
    'Core',
    'Fall',
    2024,
    20,
    '["AG201"]'
FROM departments d WHERE d.department_code = 'AG';

-- =============================================
-- VERIFICATION QUERIES
-- =============================================

-- نمایش تعداد دروس
SELECT 'Total Courses' AS description, COUNT(*) AS count FROM courses;

-- نمایش دروس بر اساس دانشکده
SELECT 
    d.department_name,
    COUNT(c.course_id) AS course_count
FROM departments d
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_name, d.department_code
ORDER BY d.department_name;

-- نمایش دروس بر اساس نوع
SELECT 
    course_type,
    COUNT(*) AS count
FROM courses
GROUP BY course_type
ORDER BY course_type;

-- نمایش دروس بر اساس ترم
SELECT 
    semester,
    COUNT(*) AS count
FROM courses
GROUP BY semester
ORDER BY semester;
