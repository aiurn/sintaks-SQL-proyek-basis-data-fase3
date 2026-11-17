-- 1. Membuat database
CREATE DATABASE Draft;


--— Tier 1
CREATE TABLE faculties (
   faculty_id VARCHAR(10) PRIMARY KEY,
   code VARCHAR(10) NOT NULL UNIQUE,
   name VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE majors (
   major_id VARCHAR(10) PRIMARY KEY,
   code VARCHAR(15) NOT NULL UNIQUE,
   name VARCHAR(100) NOT NULL
);
CREATE TABLE batches (
   batch_id VARCHAR(10) PRIMARY KEY,
   year SMALLINT NOT NULL CHECK (year BETWEEN 2000 AND 2100),
   cabinet VARCHAR(60) NOT NULL,
   scheduled_open DATE NOT NULL,
   scheduled_close DATE NOT NULL,
   CHECK (scheduled_close > scheduled_open)
);


CREATE TABLE mentors (
   mentor_id VARCHAR(10) PRIMARY KEY,
   name VARCHAR(150) NOT NULL,
   phone_number VARCHAR(20) UNIQUE,
   email VARCHAR(254) UNIQUE
);


CREATE TABLE competitions (
    competition_id VARCHAR(10)  PRIMARY KEY,
    competition_name VARCHAR(150) NOT NULL,
    year SMALLINT NOT NULL CHECK (year >= 2000),
    organizing_institution  VARCHAR(150) NOT NULL,
    cluster VARCHAR(60)  NOT NULL,
    guidebook_link VARCHAR(500) NULL
);


--— Tier 2
CREATE TABLE users (
   user_id VARCHAR(10) PRIMARY KEY,
   batch_id VARCHAR(10) REFERENCES batches(batch_id),
   faculty_id VARCHAR(10) REFERENCES faculties(faculty_id),
   major_id VARCHAR(10) REFERENCES majors(major_id),
   name VARCHAR(150) NOT NULL,
   username VARCHAR(50) UNIQUE NOT NULL,
   email VARCHAR(254) UNIQUE NOT NULL,
   nim VARCHAR(20) UNIQUE,
   forces_batch VARCHAR(10),
   password VARCHAR(255) NOT NULL,
   portfolio TEXT
);


--— Tier 3
CREATE TABLE posts (
    post_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10) NOT NULL REFERENCES users(user_id),
    competition_id VARCHAR(10) NOT NULL REFERENCES competitions(competition_id),
    quota INT NOT NULL CHECK (quota > 0),
    filled_quota INT NOT NULL DEFAULT 0,
    deadline DATE NOT NULL,
    post_date DATE NOT NULL,
    description TEXT NOT NULL,
    CHECK (filled_quota >= 0 AND filled_quota <= quota),
    CHECK (deadline >= post_date)
);


--— Tier 4
CREATE TABLE teams (
    team_id VARCHAR(10)PRIMARY KEY,
    competition_id VARCHAR(10) NOT NULL REFERENCES competitions(competition_id),
    post_id VARCHAR(10) NULL UNIQUE REFERENCES posts(post_id)
);


CREATE TABLE role_requirements (
    role_requirement_id VARCHAR(10) PRIMARY KEY,
    post_id VARCHAR(10) NOT NULL REFERENCES posts(post_id),
    required_role VARCHAR(80) NOT NULL,
    required_skill VARCHAR(255) NOT NULL,
    slot_status VARCHAR(10) NOT NULL DEFAULT 'open' CHECK (slot_status IN ('open', 'filled','closed')), 
    portofolio_requirement  VARCHAR(500)NULL
);

--— Tier 5
CREATE TABLE team_members (
   team_id VARCHAR(10) REFERENCES teams(team_id),
   user_id VARCHAR(10) REFERENCES users(user_id),
   team_role VARCHAR(60) NOT NULL,
   status VARCHAR(10) NOT NULL CHECK (status IN ('active', 'exited')),
   joined_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, PRIMARY KEY (team_id, user_id)
);


CREATE TABLE responses (
   response_id VARCHAR(10) PRIMARY KEY,
   post_id VARCHAR(10) NOT NULL REFERENCES posts(post_id),
   role_requirement_id VARCHAR(10) NOT NULL REFERENCES role_requirements(role_requirement_id),
   user_id VARCHAR(10) NOT NULL REFERENCES users(user_id),
   response_date DATE NOT NULL,
   status VARCHAR(10) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'rejected')),
   UNIQUE (role_requirement_id, user_id)
);


CREATE TYPE mentoring_status AS ENUM (
   'diajukan',
   'sedang dicarikan mentor',
   'terjadwal',
   'selesai'
);


CREATE TABLE mentoring_requests (
   mentoring_request_id VARCHAR(10) PRIMARY KEY,
   team_id VARCHAR(10) REFERENCES teams(team_id),
   mentor_id VARCHAR(10) REFERENCES mentors(mentor_id),
   batch_id VARCHAR(10) REFERENCES batches(batch_id),
   deadline DATE NOT NULL,
   competition_stage VARCHAR(100) NOT NULL,
   status mentoring_status DEFAULT 'diajukan',
   notes TEXT
);


CREATE TABLE brainstormings(
   mentoring_request_id  VARCHAR(10) PRIMARY KEY REFERENCES mentoring_requests(mentoring_request_id),
   topics TEXT
);


CREATE TABLE work_reviews(
   mentoring_request_id  VARCHAR(10) PRIMARY KEY REFERENCES mentoring_requests(mentoring_request_id),
   work_link TEXT
);


--– – Tier 1
INSERT INTO faculties (faculty_id, code, name)
VALUES
    ('FA001', 'A', 'Fakultas Pertanian'),
    ('FA002', 'B', 'Sekolah Kedokteran Hewan dan Biomedis'),
    ('FA003', 'C', 'Fakultas Perikanan dan Ilmu Kelautan'),
    ('FA004', 'M', 'Sekolah Sains Data, Matematika, dan Informatika'),
    ('FA005', 'E', 'Fakultas Kehutanan dan Lingkungan');


INSERT INTO majors (major_id, code, name)
VALUES
    ('MJ001', 'M03', 'Ilmu Komputer'),
    ('MJ002', 'M01', 'Statistika dan Sains Data'),
    ('MJ003', 'H24', 'Manajemen'),
    ('MJ004', 'A24', 'Agronomi dan Hortikultura'),
    ('MJ005', 'I14', 'Ilmu Gizi');


INSERT INTO batches (batch_id, year, cabinet, scheduled_open, scheduled_close)
VALUES
    ('BT001', 2022, 'Kabinet Akselerasi Karya', '2022-02-01', '2022-12-20'),
    ('BT002', 2023, 'Kabinet Sinergi Prestasi', '2023-02-05', '2023-12-22'),
    ('BT003', 2024, 'Kabinet Resonansi Inovasi', '2024-02-10', '2024-12-18'),
    ('BT004', 2025, 'Kabinet Eskalasi Juara', '2025-02-03', '2025-12-19'),
    ('BT005', 2026, 'Kabinet Katalis Prestasi', '2026-02-02', '2026-12-21');


INSERT INTO mentors (mentor_id, name, phone_number, email)
VALUES
    ('MN0001', 'Andi Pratama', '081234567890', 'andi@gmail.com'),
    ('MN0002', 'Zahra Putri', '082137817780', 'zahra@gmail.com'),
    ('MN0003', 'Putri Eka', '081789675167', 'putri@gmail.com'),
    ('MN0004', 'Eliana', '082118616172', 'eliana@gmail.com'),
    ('MN0005', 'Budi Santoso', '082345678901', 'budi@gmail.com');


INSERT INTO competitions (competition_id, competition_name, year, organizing_institution, cluster, guidebook_link)
VALUES
    ('CP0001', 'GEMASTIK XVII', 2026, 'Puspresnas Kemendikbudristek', 'Teknologi Informasi', 'https://gemastik.kemdikbud.go.id/guidebook-ppl.pdf'),
    ('CP0002', 'COMPFEST 18', 2026, 'Fasilkom Universitas Indonesia', 'Teknologi Informasi', 'https://compfest.id/guidebook-bitc.pdf'),
    ('CP0003', 'PKM-KC', 2026, 'Belmawa Kemendikbudristek', 'Karya Tulis & Inovasi', NULL),
    ('CP0004', 'Satria Data', 2026, 'Puspresnas Kemendikbudristek', 'Sains Data & AI', 'https://satriadata.kemdikbud.go.id/guidebook-bdc.pdf'),
    ('CP0005', 'Hackathon Merdeka AI', 2026, 'Kementerian Komunikasi dan Digital', 'Teknologi Informasi', NULL);


--– – Tier 2
INSERT INTO users (user_id, batch_id, faculty_id, major_id, name, username, email, nim, forces_batch, password)
VALUES
    ('US0001', 'BT001', 'FA004', 'MJ002', 'Nurul Auliya', 'nurul123', 'nurul@gmail.com', 'M040525104', '23', '<HASH_PASSWORD_1>'),
    ('US0002', 'BT001', 'FA004', 'MJ002', 'Shelby', 'shelby', 'shelby@gmail.com', 'M040525107', '23', '<HASH_PASSWORD_2>'),
    ('US0003', 'BT002', 'FA004', 'MJ002', 'Danish', 'danish', 'danish@gmail.com', 'M040525102', '23', '<HASH_PASSWORD_3>'),
    ('US0004', 'BT001', 'FA001', 'MJ004', 'Despita', 'pita', 'pita@gmail.com', 'H156281888', '23', '<HASH_PASSWORD_4>'),
    ('US0005', 'BT004', 'FA004', 'MJ001', 'Imah', 'imah', 'imah@gmail.com', 'H156281789', '23', '<HASH_PASSWORD_5>');


--– – Tier 3
INSERT INTO posts (post_id, user_id, competition_id, quota, filled_quota, deadline, post_date, description)
VALUES
    ('PS0001', 'US0001', 'CP0001', 3, 1, '2026-08-15', '2026-07-20', 'Dicari anggota tim GEMASTIK PPL yang siap komitmen riset dan pengembangan aplikasi sampai tahap final.'),
    ('PS0002', 'US0002', 'CP0002', 2, 0, '2026-09-01', '2026-08-10', 'Open recruitment tim Business IT Case COMPFEST, diutamakan yang paham analisis finansial dan pitching.'),
    ('PS0003', 'US0003', 'CP0003', 4, 2, '2026-05-10', '2026-04-15', 'Mencari anggota tim PKM-KC bidang pengembangan perangkat IoT pertanian cerdas.'),
    ('PS0004', 'US0004', 'CP0004', 3, 3, '2026-07-30', '2026-07-01', 'Tim Satria Data BDC mencari data analyst untuk pengolahan dataset dan pemodelan prediktif.'),
    ('PS0005', 'US0005', 'CP0005', 4, 1, '2026-10-20', '2026-10-01', 'Dicari rekan tim hackathon AI untuk membangun solusi automasi layanan publik berbasis LLM.');


--– – Tier 4
INSERT INTO teams (team_id, competition_id, post_id)
VALUES
    ('TM0001', 'CP0001', 'PS0001'),
    ('TM0002', 'CP0002', 'PS0002'),
    ('TM0003', 'CP0003', 'PS0003'),
    ('TM0004', 'CP0004', 'PS0004'),
    ('TM0005', 'CP0005', NULL);

INSERT INTO role_requirements (role_requirement_id, post_id, required_role, required_skill, slot_status, portofolio_requirement)
VALUES
    ('RR0001', 'PS0001', 'UI/UX Designer', 'Figma, Wireframing, Prototyping', 'filled', 'https://dribbble.com/contoh-portofolio'),
    ('RR0002', 'PS0001', 'Backend Developer', 'PostgreSQL, Node.js, REST API', 'open', 'https://github.com/contoh-repository'),
    ('RR0003', 'PS0002', 'Business Analyst', 'Market Sizing, Financial Modeling, Pitch Deck', 'open', NULL),
    ('RR0004', 'PS0003', 'IoT Engineer', 'ESP32, C++, Integrasi Sensor', 'closed', 'Link dokumentasi proyek elektronika atau IoT'),
    ('RR0005', 'PS0005', 'AI/ML Engineer', 'Python, PyTorch, NLP, API Integration', 'open', 'https://github.com/contoh-ai-project');

--– – Tier 5
INSERT INTO team_members (team_id, user_id, team_role, status, joined_at)
VALUES
    ('TM0001', 'US0001', 'Team Leader & Fullstack Developer', 'active', '2026-07-20 10:15:00'),
    ('TM0001', 'US0002', 'UI/UX Designer', 'active', '2026-07-25 14:30:00'),
    ('TM0002', 'US0002', 'Project Manager', 'active', '2026-08-10 09:00:00'),
    ('TM0003', 'US0003', 'Lead IoT Engineer', 'active', '2026-04-15 16:45:00'),
    ('TM0003', 'US0004', 'Hardware Researcher', 'exited', '2026-04-18 11:20:00');


INSERT INTO responses (response_id, post_id, role_requirement_id, user_id, response_date, status)
VALUES
    ('RP0001', 'PS0001', 'RR0001', 'US0002', '2026-07-22', 'accepted'),
    ('RP0002', 'PS0001', 'RR0002', 'US0003', '2026-07-24', 'pending'),
    ('RP0003', 'PS0002', 'RR0003', 'US0004', '2026-08-12', 'pending'),
    ('RP0004', 'PS0003', 'RR0004', 'US0005', '2026-04-17', 'rejected'),
    ('RP0005', 'PS0005', 'RR0005', 'US0001', '2026-10-03', 'pending');


INSERT INTO mentoring_requests (mentoring_request_id, team_id, mentor_id, batch_id, deadline, competition_stage, status, notes)
VALUES
    ('MR0001', 'TM0001', 'MN0004', 'BT001', '2026-11-27', 'Semifinal', 'sedang dicarikan mentor', 'Membutuhkan mentor bidang kesehatan'),
    ('MR0002', 'TM0003', 'MN0004', 'BT002', '2026-12-01', 'Semifinal', 'selesai', 'Membutuhkan mentor bidang pertanian'),
    ('MR0003', 'TM0003', 'MN0001', 'BT001', '2026-12-20', 'Semifinal', 'diajukan', 'Membutuhkan mentor bidang teknologi'),
    ('MR0004', 'TM0004', 'MN0003', 'BT003', '2026-11-10', 'Semifinal', 'selesai', 'Perlu eksplorasi ide'),
    ('MR0005', 'TM0005', 'MN0002', 'BT004', '2026-12-25', 'Final', 'terjadwal', 'Membutuhkan arahan untuk presentasi');


--– – Tier 6
INSERT INTO brainstormings (mentoring_request_id, topics)
VALUES
    ('MR0001', 'Pengembangan aplikasi berbasis AI untuk pendidikan'),
    ('MR0002', 'Pengembangan sistem monitoring lingkungan'),
    ('MR0003', 'Restrukturisasi Pemerintahan demi Kedaulatan Pangan Indonesia 2027'),
    ('MR0004', 'Analisis Hubungan Uang Saku dengan tingkat Kebahagiaan Mahasiswa'),
    ('MR0005', 'Pengembangan AI agent di lingkungan dengan cuaca ekstrem');


INSERT INTO work_reviews (mentoring_request_id, work_link)
VALUES
    ('MR0001', 'https://docs.google.com/document/d/1aBcDeFgHiJkLmNoPqRsTuVwXyZ_Proposal_GEMASTIK'),
    ('MR0002', 'https://www.figma.com/file/9xYzAbCdEfGhIjKlMnOpQr_Prototype_UIUX'),
    ('MR0003', 'https://drive.google.com/file/d/2mNoPqRsTuVwXyZaBcDeFgHiJk_PitchDeck_COMPFEST'),
    ('MR0004', 'https://docs.google.com/document/d/3pQrStUvWxYzAbCdEfGhIjKlMn_Laporan_PKM_KC'),
    ('MR0005', 'https://github.com/tim-satriadata/modeling-notebook-bdc');




--Menampilkan data user beserta informasi lainnya dari tabel lain
CREATE VIEW v_users AS
SELECT
	u.user_id,
	u.name,
	u.username,
	u.email,
	u.nim,
	u.forces_batch,
	b.batch_id,
	b.year AS batch_year,
	f.faculty_id,
	f.code AS faculty_code,
	f.name AS faculty_name,
	m.major_id,
	m.code AS major_code,
	m.name AS major_name
FROM users u
LEFT JOIN batches b
	ON u.batch_id = b.batch_id
LEFT JOIN faculties f
	ON u.faculty_id = f.faculty_id
LEFT JOIN majors m
	ON u.major_id = m.major_id;


--Menampilkan data kompetisi beserta tim dan informasi rekrutmen
CREATE VIEW v_competitions AS
SELECT 
	c.competition_id,
	c.competition_name,
	c.cluster as competition_cluster,
	c.year,
	c.organizing_institution,
	c.cluster,
	c.guidebook_link,
	t.team_id,
	p.post_id,
	p.quota,
	p.filled_quota
FROM competitions c
LEFT JOIN teams t
	ON c.competition_id = t.competition_id
LEFT JOIN posts p
	ON t.post_id = p.post_id;


--Menampilkan data anggota tim beserta peran dan status keanggotaan
CREATE VIEW v_team_members AS
SELECT 
	t.team_id,
	c.competition_name,
	p.post_id,
	u.user_id,
	u.name,
	tm.team_role,
	tm.status AS team_member_status,
	tm.joined_at
FROM teams t
JOIN competitions c
	ON t.competition_id = c.competition_id
LEFT JOIN posts p
	ON t.post_id = p.post_id
LEFT JOIN team_members tm
	ON t.team_id = tm.team_id
LEFT JOIN users u
	ON tm.user_id = u.user_id;


--Menampilkan informasi postingan rekrutmen Community Hub
CREATE VIEW v_posts AS
SELECT 
	p.post_id,
	u.name,
	c.competition_name,
	c.cluster AS competition_cluster,
	t.team_id,
	p.quota,
	p.filled_quota,
	p.deadline,
	p.post_date,
	p.description
FROM posts p
JOIN users u
	ON p.user_id = u.user_id
JOIN competitions c
	ON p.competition_id = c.competition_id
LEFT JOIN teams t
	ON p.post_id = t.post_id;


--Menampilkan kebutuhan posisi dan skill pada setiap postingan
CREATE VIEW v_role_requirements AS
SELECT
    rr.role_requirement_id,
    p.post_id,
    p.competition_id,
    c.competition_name,
    p.description,
    rr.required_role,
    rr.required_skill,
    rr.slot_status,
    rr.portofolio_requirement,
    p.quota,
    p.filled_quota,
    p.deadline
FROM role_requirements rr
JOIN posts p
    ON rr.post_id = p.post_id
JOIN competitions c
    ON p.competition_id = c.competition_id;


--Menampilkan data respons atau lamaran pengguna terhadap rekrutmen
CREATE VIEW v_responses AS
SELECT
	r.response_id,
	u.user_id,
	u.name,
	p.post_id,
	p.description,
	rr.required_role,
	rr.required_skill,
	r.response_date,
	r.status AS response_status
FROM responses r
JOIN posts p
	ON r.post_id = p.post_id
JOIN role_requirements rr
	ON r.role_requirement_id = rr.role_requirement_id
JOIN users u
	ON r.user_id = u.user_id;


--Menampilkan informasi pengajuan mentoring dan brainstorming
CREATE VIEW v_mentoring_requests AS
SELECT
    mr.mentoring_request_id,
    t.team_id,
    m.mentor_id,
    m.name AS mentor_name,
    b.batch_id,
    b.year AS batch_year,
    mr.deadline,
    mr.competition_stage,
    mr.status,
    mr.notes,
    br.topics
FROM mentoring_requests mr
LEFT JOIN teams t
    ON mr.team_id = t.team_id
LEFT JOIN mentors m
    ON mr.mentor_id = m.mentor_id
LEFT JOIN batches b
    ON mr.batch_id = b.batch_id
LEFT JOIN brainstormings br
    ON mr.mentoring_request_id = br.mentoring_request_id;


--Menampilkan progres kerja tim sebelum mentoring
CREATE VIEW v_work_reviews AS
SELECT
    wr.mentoring_request_id,
    mr.team_id,
    t.team_id AS team_reference,
    m.name AS mentor_name,
    mr.competition_stage,
    mr.status AS mentoring_status,
    wr.work_link
FROM work_reviews wr
JOIN mentoring_requests mr
    ON wr.mentoring_request_id = mr.mentoring_request_id
LEFT JOIN teams t
    ON mr.team_id = t.team_id
LEFT JOIN mentors m
    ON mr.mentor_id = m.mentor_id;


SELECT * FROM v_users;

SELECT * FROM v_competitions;

SELECT * FROM v_team_members;

SELECT * FROM v_posts;

SELECT * FROM v_role_requirements;

SELECT * FROM v_responses;

SELECT * FROM v_mentoring_requests;

SELECT * FROM v_work_reviews;


--Mencari user berdasarkan tahun angkatan
SELECT * FROM v_users WHERE batch_year = 2022;

--Mencari user berdasarkan peran pekerjaannya dan status keanggotaannya
SELECT * FROM v_team_members WHERE team_role ILIKE '%UI/UX%' AND team_member_status = 'active';

--Mencari kompetisi berdasarkan nama
SELECT * FROM v_competitions WHERE competition_name ILIKE '%GEMASTIK%';

--Mencari kompetisi berdasarkan cluster
SELECT DISTINCT 
	competition_id,
	competition_name,
	year,
	competition_cluster
FROM v_competitions
WHERE competition_cluster ILIKE '%Sains Data%';

--Mencari rekrutmen berdasarkan posisi yang dibutuhkan
SELECT 
	post_id,
	description,
	required_role,
	required_skill,
	slot_status,
	deadline
FROM v_role_requirements
WHERE required_role ILIKE '%UI/UX%' AND slot_status = 'open';

--Mencari rekrutmen berdasarkan skill yang dibutuhkan
SELECT 
	post_id,
	required_role,
	required_skill,
	slot_status
FROM v_role_requirements
WHERE required_skill ILIKE '%Python%' AND slot_status = 'open';

--Mencari rekrutmen yang masih tersedia
SELECT
    post_id,
    competition_name,
    required_role,
    required_skill,
    slot_status,
    quota,
    filled_quota,
    deadline
FROM v_role_requirements
WHERE slot_status = 'open'
AND filled_quota < quota;

--Mencari pengajuan berdasarkan statusnya
SELECT * FROM v_mentoring_requests WHERE status = 'diajukan';

--Mencari pengajuan berdasarkan tahapan kompetisinya
SELECT * FROM v_mentoring_requests WHERE competition_stage = 'Final';

--Cek progres kerja tim yang mengajukan mentoring
SELECT
    mentoring_request_id,
    team_id,
    mentor_name,
    competition_stage,
    mentoring_status,
    work_link
FROM v_work_reviews;

--Mencari pengajuan mentoring berdasarkan status dan tahapan kompetisinya
SELECT
    mentoring_request_id,
    competition_stage,
    status,
    deadline
FROM v_mentoring_requests
WHERE status = 'terjadwal'
AND competition_stage = 'Final';


--Melacak status ketersediaan dan keterisian slot anggota pada postingan Community Hub
SELECT
    vp.post_id,
    vp.name AS post_creator,
    vp.competition_name,
    vp.competition_cluster,
    vp.filled_quota || '/' || vp.quota AS quota_progress,
    (vp.quota - vp.filled_quota) AS remaining_slots,
    CASE
        WHEN vp.filled_quota >= vp.quota THEN 'Penuh'
        WHEN vp.deadline < CURRENT_DATE THEN 'Ditutup (Deadline Lewat)'
        ELSE 'Tersedia'
    END AS post_availability_status,
    vrr.role_requirement_id,
    vrr.required_role,
    vrr.slot_status AS role_slot_status,
    vrr.portofolio_requirement,
    vp.deadline
FROM v_posts vp
LEFT JOIN v_role_requirements vrr
    ON vp.post_id = vrr.post_id
--– Uncomment jika ingin melihat yang open saja
-- WHERE vp.filled_quota < vp.quota AND vrr.slot_status = 'open'
ORDER BY vp.post_id, vrr.role_requirement_id;


--– – Melacak status tahapan kompetisi yang sedang dijalani oleh tim atau anggota, seperti brainstorming, penyusunan proposal, dan tahapan lainnya sesuai jenis kompetisi.
SELECT
    vtm.team_id,
    vtm.user_id,
    vtm.name AS member_name,
    vtm.team_role,
    vc.competition_name,
    vc.cluster AS competition_type,
    COALESCE(vmr.competition_stage, 'Persiapan Awal') AS competition_stage,
	 CASE
	    WHEN vmr.topics IS NOT NULL AND vwr.work_link IS NOT NULL
	        THEN 'Brainstorming & Penyusunan/Review Proposal'
	    WHEN vmr.topics IS NOT NULL
	        THEN 'Brainstorming'
	    WHEN vwr.work_link IS NOT NULL
	        THEN 'Penyusunan / Review Proposal & Karya'
	    ELSE 'Tahap Umum / Belum Ada Mentoring'
	END AS stage_activity,
	COALESCE(vmr.topics, vwr.work_link, '-') AS stage_detail,
    COALESCE(vmr.status::TEXT, '-') AS mentoring_status,
    vmr.deadline AS stage_deadline,
    COALESCE(vmr.mentor_name, 'Belum Ditentukan') AS mentor_name
FROM v_team_members vtm
JOIN v_competitions vc
    ON vtm.team_id = vc.team_id
LEFT JOIN v_mentoring_requests vmr
    ON vtm.team_id = vmr.team_id
LEFT JOIN v_work_reviews vwr
    ON vmr.mentoring_request_id = vwr.mentoring_request_id
WHERE vtm.team_member_status = 'active'
-- Uncomment jika ingin mencari tim atau member spesifik:
-- AND vtm.team_id = 'TM0001'
-- AND vtm.user_id = 'US0001'
ORDER BY vtm.team_id, vtm.user_id, vmr.deadline ASC;


 -- Menampilkan informasi postingan, kuota, jumlah slot terisi, dan status pemenuhan posisi anggota
SELECT
   p.post_id,
   u.name AS post_creator,
   c.competition_name,
   c.cluster AS competition_cluster,
   p.quota,
   p.filled_quota,
   (p.quota - p.filled_quota) AS remaining_slots,
   COUNT(rr.role_requirement_id) AS total_positions,
   COUNT(rr.role_requirement_id) FILTER (WHERE rr.slot_status = 'filled') AS filled_positions,
   COUNT(rr.role_requirement_id) FILTER (WHERE rr.slot_status = 'open') AS open_positions,
   COUNT(rr.role_requirement_id) FILTER (WHERE rr.slot_status = 'closed') AS closed_positions,
   CASE
       WHEN p.filled_quota >= p.quota THEN 'Penuh'
       WHEN p.deadline < CURRENT_DATE THEN 'Ditutup'
       ELSE 'Tersedia'
   END AS post_status
FROM posts p
JOIN users u
   ON p.user_id = u.user_id
JOIN competitions c
   ON p.competition_id = c.competition_id
LEFT JOIN role_requirements rr
   ON p.post_id = rr.post_id
GROUP BY
   p.post_id,
   u.name,
   c.competition_name,
   c.cluster,
   p.quota,
   p.filled_quota,
   p.deadline
ORDER BY p.post_id;


-- Menampilkan jumlah permintaan mentoring berdasarkan batch, cluster kompetisi, dan status mentoring
SELECT
   b.batch_id,
   b.year AS batch_year,
   b.cabinet,
   c.cluster AS competition_cluster,
   mr.status AS mentoring_status,
   COUNT(mr.mentoring_request_id) AS total_requests
FROM mentoring_requests mr
LEFT JOIN batches b
   ON mr.batch_id = b.batch_id
LEFT JOIN teams t
   ON mr.team_id = t.team_id
LEFT JOIN competitions c
   ON t.competition_id = c.competition_id
GROUP BY
   b.batch_id,
   b.year,
   b.cabinet,
   c.cluster,
   mr.status
ORDER BY
   b.year,
   b.batch_id,
   c.cluster,
   Mr.status;


-- Menampilkan mentor yang ditugaskan beserta tim, kompetisi, dan anggota yang dibimbing
SELECT
   m.mentor_id,
   m.name AS mentor_name,
   mr.mentoring_request_id,
   t.team_id,
   c.competition_name,
   mr.competition_stage,
   mr.status AS mentoring_status,
   u.user_id,
   u.name AS member_name,
   tm.team_role,
   tm.status AS team_member_status
FROM mentoring_requests mr
JOIN mentors m
   ON mr.mentor_id = m.mentor_id
JOIN teams t
   ON mr.team_id = t.team_id
JOIN competitions c
   ON t.competition_id = c.competition_id
LEFT JOIN team_members tm
   ON t.team_id = tm.team_id
   AND tm.status = 'active'
LEFT JOIN users u
   ON tm.user_id = u.user_id
WHERE mr.mentor_id IS NOT NULL
ORDER BY
   m.name,
   mr.mentoring_request_id,
   u.name;


-- Membuat tabel untuk menyimpan feedback mentor terhadap hasil pekerjaan peserta
CREATE TABLE feedbacks (
   feedback_id VARCHAR(10) PRIMARY KEY,
   mentoring_request_id VARCHAR(10) NOT NULL REFERENCES work_reviews(mentoring_request_id),
   feedback_date DATE NOT NULL DEFAULT CURRENT_DATE,
   feedback_text TEXT NOT NULL
);


-- Menampilkan feedback mentor beserta tim, kompetisi, dan hasil pekerjaan peserta
SELECT
   f.feedback_id,
   f.feedback_date,
   f.feedback_text,
   wr.mentoring_request_id,
   m.mentor_id,
   m.name AS mentor_name,
   t.team_id,
   c.competition_name,
   mr.competition_stage,
   mr.status AS mentoring_status,
   wr.work_link
FROM feedbacks f
JOIN work_reviews wr
   ON f.mentoring_request_id = wr.mentoring_request_id
JOIN mentoring_requests mr
   ON wr.mentoring_request_id = mr.mentoring_request_id
LEFT JOIN mentors m
   ON mr.mentor_id = m.mentor_id
LEFT JOIN teams t
   ON mr.team_id = t.team_id
LEFT JOIN competitions c
   ON t.competition_id = c.competition_id
ORDER BY
   f.feedback_date DESC,
   f.feedback_id;

