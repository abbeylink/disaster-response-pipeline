-- STAGING 
create table if not exists stg_projects (
    gmProjectId bigint primary key,
    disasterNumber INT,
    declarationDate DATE
    incidentType TEXT,
    pwNumber int,
    applicationTitle TEXT,
    applicantId TEXT,
    damageCategoryCode TEXT,
    damageCategoryDescrip TEXT,
    projectStatus TEXT,
    projectProcessStep TEXT,
    projectSize TEXT,
    county TEXT,
    countyCode TEXT,
    stateAbbreviation TEXT,
    stateNumberCode TEXT,
    projectAmount DECIMAL,
    federalShareObligated DECIMAL,
    totalObligated DECIMAL,
    firstObligationDate timestamp,
    lastObligationDate timestamp,
    mitigationAmount DECIMAL,
    gmApplicantId bigint,
    lastRefresh timestamp
);

-- DIMENSIONS 
create table if not exists dim_disaster (
    disasterNumber int primary key,
    declarationDate date,
    incidentType text
);

create table if not exists dim_location (
    stateAbbreviation text,
    county text,
    countyCode text,
    primary key (stateAbbreviation, county, countyCode)
);

-- FACT 
create table if not exists fact_project (
    gmProjectId bigint primary key references stg_projects(gmProjectId),
    disasterNumber int references dim_disaster(disasterNumber),
    stateAbbreviation text,
    county text,
    projectAmount numeric,
    federalShareObligated numeric,
    totalObligated numeric,
    firstObligationDate date,
    lastObligationDate date,
    obligation_gap_days int,
    federal_share_percent numeric
);

-- ========== INDEXES ==========
create index if not exists idx_fact_project_disaster on fact_project(disasterNumber);
create index if not exists idx_fact_project_state on fact_project(stateAbbreviation);
create index if not exists idx_fact_project_dates on fact_project(firstObligationDate, lastObligationDate);
