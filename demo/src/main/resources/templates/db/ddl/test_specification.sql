-- Project Name : test_specification
-- Date/Time    : 2022/04/24 18:29:41
-- Author       : masshun
-- RDBMS Type   : PostgreSQL
-- Application  : A5:SQL Mk-2

/*
  << 注意！！ >>
  BackupToTempTable, RestoreFromTempTable疑似命令が付加されています。
  これにより、drop table, create table 後もデータが残ります。
  この機能は一時的に $$TableName のような一時テーブルを作成します。
  この機能は A5:SQL Mk-2でのみ有効であることに注意してください。
*/

-- タグ
--* RestoreFromTempTable
create table m_tag (
  tag_id integer not null
  , tag_name varchar(100) not null
  , created_at timestamp with time zone default now() not null
  , constraint m_tag_PKC primary key (tag_id)
) ;

-- アカウント
--* RestoreFromTempTable
create table m_account (
  account_id integer not null
  , account_name varchar(100) not null
  , email varchar(255) not null
  , created_at timestamp with time zone default now() not null
  , constraint account_PKC primary key (account_id)
) ;

-- ロール
--* RestoreFromTempTable
create table m_role (
  role_id integer not null
  , role_name varchar(100) not null
  , role_type integer not null
  , created_at timestamp with time zone default now() not null
  , constraint m_role_PKC primary key (role_id)
) ;

-- テスト仕様書
--* RestoreFromTempTable
create table m_test_spec (
  test_spec_id integer not null
  , title varchar(50) not null
  , tested_dt timestamp with time zone
  , test_supplement varchar(255)
  , created_at timestamp with time zone default now() not null
  , constraint m_test_spec_PKC primary key (test_spec_id)
) ;

-- テストスイート
--* RestoreFromTempTable
create table m_test_suite (
  test_suite_id integer not null
  , test_target varchar(100) not null
  , expected varchar(255) not null
  , testSupplement varchar(255)
  , created_at timestamp with time zone default now() not null
  , constraint m_test_suite_PKC primary key (test_suite_id)
) ;

-- テストケース
--* RestoreFromTempTable
create table m_test_case (
  test_case_id integer not null
  , target varchar(100) not null
  , expected varchar(255) not null
  , test_supplement varchar(255)
  , status integer default 0 not null
  , created_at timestamp with time zone default now() not null
  , constraint m_test_case_PKC primary key (test_case_id)
) ;

-- 取引先
-- * RestoreFromTempTable
create table m_supplier (
  supplier_id integer not null
  , supplier_name varchar(100) not null
  , description varchar(255) not null
  , created_at timestamp with time zone default now() not null
  , constraint m_supplier_PKC primary key (supplier_id)
) ;

-- テストスイート-テストケースリレーション
--* RestoreFromTempTable
create table r_test_suite_test_case (
  test_suite_id integer not null
  , test_case_id integer not null
  , foreign key (test_suite_id) references m_test_suite(test_suite_id)
  on delete cascade
  , foreign key (test_case_id) references m_test_case(test_case_id)
  on delete cascade
) ;

alter table r_test_suite_test_case add constraint r_test_suite_test_case_IX1
  unique (test_case_id,test_suite_id) ;

-- テスト仕様書-アカウントリレーション
--* RestoreFromTempTable
create table r_test_spec_account (
  test_spec_id integer not null
  , account_id integer not null
  , foreign key (test_spec_id) references m_test_spec(test_spec_id)
  on delete cascade
  , foreign key (account_id) references m_account(account_id)
  on delete cascade
) ;

alter table r_test_spec_account add constraint r_test_spec_account_IX1
  unique (test_spec_id,account_id) ;

-- タグ-テストケースリレーション
--* RestoreFromTempTable
create table r_tag_test_case (
  tag_id integer not null
  , test_case_id integer not null
  , foreign key (tag_id) references m_tag(tag_id)
  on delete cascade
  , foreign key (test_case_id) references m_test_case(test_case_id)
  on delete cascade
) ;

alter table r_tag_test_case add constraint r_tag_test_case_IX1
  unique (test_case_id,tag_id) ;

-- タグ-テストスイートリレーション
--* RestoreFromTempTable
create table r_tag_test_suite (
  tag_id integer not null
  , test_suite_id integer not null
  , foreign key (tag_id) references m_tag(tag_id)
  on delete cascade
  , foreign key (test_suite_id) references m_test_suite(test_suite_id)
  on delete cascade
) ;

alter table r_tag_test_suite add constraint r_tag_test_suite_IX1
  unique (test_suite_id,tag_id) ;

-- テスト仕様書-テストスイートリレーション
--* RestoreFromTempTable
create table r_test_spec_test_suite (
  test_spec_id integer not null
  , test_suite_id integer not null
  , foreign key (test_spec_id) references m_test_spec(test_spec_id)
  on delete cascade
  , foreign key (test_suite_id) references m_test_suite(test_suite_id)
  on delete cascade
) ;

alter table r_test_spec_test_suite add constraint r_test_spec_test_suite_IX1
  unique (test_suite_id,test_spec_id) ;

-- アカウント-ロールリレーション
--* RestoreFromTempTable
create table r_account_role (
  account_id integer not null
  , role_id integer not null
  , foreign key (account_id) references m_account(account_id)
  on delete cascade
  , foreign key (role_id) references m_role(role_id)
  on delete cascade
) ;

alter table r_account_role add constraint r_account_role_IX1
  unique (account_id,role_id) ;

-- テスト仕様書-取引先リレーション
--* RestoreFromTempTable
create table r_test_spec_supplier (
  test_spec_id integer not null
  , supplier_id integer not null
  , foreign key (test_spec_id) references m_test_spec(test_spec_id)
  on delete cascade
  , foreign key (supplier_id) references m_supplier(supplier_id)
  on delete cascade
);

alter table r_test_spec_supplier add constraint r_test_spec_supplier_IX1
  unique (test_spec_id,supplier_id) ;

comment on table r_test_suite_test_case is 'テストスイート-テストケースリレーション';
comment on column r_test_suite_test_case.test_suite_id is 'テストスイートID';
comment on column r_test_suite_test_case.test_case_id is 'テストケースID';

comment on table r_test_spec_account is 'テスト仕様書-アカウントリレーション';
comment on column r_test_spec_account.test_spec_id is 'テスト仕様書ID';
comment on column r_test_spec_account.account_id is 'アカウントID';

comment on table r_tag_test_case is 'タグ-テストケースリレーション';
comment on column r_tag_test_case.tag_id is 'タグID';
comment on column r_tag_test_case.test_case_id is 'テストケースID';

comment on table r_tag_test_suite is 'タグ-テストスイートリレーション';
comment on column r_tag_test_suite.tag_id is 'タグID';
comment on column r_tag_test_suite.test_suite_id is 'テストスイートID';

comment on table m_tag is 'タグ';
comment on column m_tag.tag_id is 'タグID';
comment on column m_tag.tag_name is 'タグ名';

comment on table m_test_suite is 'テストスイート';
comment on column m_test_suite.test_suite_id is 'テストスイートID';
comment on column m_test_suite.test_target is 'テスト対象';
comment on column m_test_suite.expected is '期待内容';
comment on column m_test_suite.testSupplement is '備考';

comment on table r_test_spec_test_suite is 'テスト仕様書-テストスイートリレーション';
comment on column r_test_spec_test_suite.test_spec_id is 'テスト仕様書ID';
comment on column r_test_spec_test_suite.test_suite_id is 'テストスイートID';

comment on table m_test_case is 'テストケース';
comment on column m_test_case.test_case_id is 'テストケースID';
comment on column m_test_case.target is 'テスト対象';
comment on column m_test_case.expected is '期待内容';
comment on column m_test_case.test_supplement is '備考';
comment on column m_test_case.status is '状態:0:未実施1:テスト中2:完了3:保留4:開発者対応中';

comment on table r_account_role is 'アカウント-ロールリレーション';
comment on column r_account_role.account_id is 'アカウントID';
comment on column r_account_role.role_id is 'ロールID';

comment on table m_role is 'ロール';
comment on column m_role.role_id is 'ロールID';
comment on column m_role.role_name is 'ロール名';
comment on column m_role.created_at is '作成日時';

comment on table m_account is 'アカウント';
comment on column m_account.account_id is 'アカウントID';
comment on column m_account.account_name is 'アカウント名';
comment on column m_account.email is 'メールアドレス';
comment on column m_account.created_at is '作成日時';

comment on table m_test_spec is 'テスト仕様書';
comment on column m_test_spec.test_spec_id is '仕様書ID';
comment on column m_test_spec.title is 'タイトル';
comment on column m_test_spec.tested_dt is 'テスト実施日時';
comment on column m_test_spec.test_supplement is '備考';
comment on column m_test_spec.created_at is '作成日時';

comment on table m_supplier is '取引先';
comment on column m_supplier.supplier_id is '取引先ID';
comment on column m_supplier.supplier_name is '取引先名';
comment on column m_supplier.description is '備考';
comment on column m_supplier.created_at is '作成日時';

comment on table r_test_spec_supplier is 'テスト仕様書-取引先リレーション';
comment on column r_test_spec_supplier.test_spec_id is 'テスト仕様書ID';
comment on column r_test_spec_supplier.supplier_id is '取引先ID';

