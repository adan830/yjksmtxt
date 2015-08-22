unit DataFieldConst;

interface

uses
   Classes;

const
   // ==============================================================================
   // 以下常量为 考生库 考试数据库 所用的 表名
   // ==============================================================================

   TBLNAME_EXAMDB_TQ   = '试题';
   TBANAME_EXAMDB_INFO = '考生信息';

   // ==============================================================================
   // 以下常量为 系统题库  数据库中 表名
   // ==============================================================================

   TBLNAME_TQDB_TQ = '试题';

   // ==============================================================================
   // 以下常量为 系统题库  中保存的空考生数据库的文件ID
   // ==============================================================================

   CLIENTDB_FILEID = '1';

   // ==============================================================================
   // 默认系统题库文件名
   // ==============================================================================
   DEFAULTSYSDB_FILENAME = '系统题库.mdb';
   // ==============================================================================
   // 以下常量为 考生数据库文件默认文件名
   // ==============================================================================

   CLIENTDB_FILENAME = '考生题库.dat';

   // ==============================================================================
   // 评分信息数据库名
   // ==============================================================================
   GRADEINFO_FILENAME = 'Gradeinfo.mdb';

   // ==============================================================================
   // 以下 常量为 试题 表中字段名
   // 系统题库 和 考生题库 共用 但考生题库只包含其中的部分
   // ==============================================================================

   // data field name const for 试题 table
   DFNTQ_ST_NO       = 'st_no';
   DFNTQ_CONTENT     = 'Content';
   DFNTQ_ENVIRONMENT = 'Environment';
   DFNTQ_STANSWER    = 'StAnswer';
   DFNTQ_KSDA        = 'ksda';
   DFNTQ_COMMENT     = 'Comment';
   DFNTQ_POINTID     = 'PointID';
   DFNTQ_TIMESTAMP   = 'TimeStamp';
   DFNTQ_DIFFICULTY  = 'Difficulty'; // 试题难度
   DFNTQ_TOTALRIGHT  = 'TotalRight'; // 总正确数
   DFNTQ_TOTALUSED   = 'TotalUsed';  // 总使用数
   DFNTQ_REDACTTIME  = 'RedactTime'; // 修订时间
   DFNTQ_REDACTOR    = 'Redactor';   // 修订者
   DFNTQ_ISMODIFIED  = 'IsModified'; // 是否修改标记
   // 新库中并不包含以下字段，只为转换旧题库用
   DFNTQ_ST_LR    = 'st_lr';
   DFNTQ_ST_ITEM1 = 'st_item1';
   DFNTQ_ST_ITEM2 = 'st_item2';
   DFNTQ_ST_ITEM3 = 'st_item3';
   DFNTQ_ST_ITEM4 = 'st_item4';
   DFNTQ_ST_DA    = 'st_da';

   DFNTQ_ST_HJ      = 'st_hj';
   DFNTQ_ST_DA1     = 'st_da1';
   DFNTQ_ST_COMMENT = 'st_comment';
   {$REGION '------ 考生信息 -----'}
   // ==============================================================================
   // 以下
   // data field name const for 考生信息 table
   // ==============================================================================
   // data field name const for 考生信息 table
   DFNEI_EXAMINEEID   = 'ExamineeID';
   DFNEI_EXAMINEENAME = 'ExamineeName';
   DFNEI_IP           = 'IP';
   DFNEI_PORT         = 'Port';
   DFNEI_STATUS       = 'Status';
   DFNEI_REMAINTIME   = 'RemainTime';
   DFNEI_TIMESTAMP    = 'Stamp';
   DFNEI_SCOREINFO    = 'ScoreInfo';
   DFNEI_SCORE        = 'Score'; // 只用在汇总成绩表中
   // 以下几个字段是用来保存解密数据的
   DFNEI_DECRYPTEDID         = 'DeCryptedID';
   DFNEI_DECRYPTEDNAME       = 'DeCryptedName';
   DFNEI_DECRYPTEDSTATUS     = 'DeCryptedStatus';
   DFNEI_DECRYPTEDIP         = 'DeCryptedIP';
   DFNEI_DECRYPTEDPORT       = 'DeCryptedPort';
   DFNEI_DECRYPTEDREMAINTIME = 'DeCryptedRemainTime';
   DFNEI_DECRYPTEDTIMESTAMP  = 'DeCryptedTimeStamp';
   // data field length const for 考生信息 table
   DFNLENEI_EXAMINEEID   = 24; // Text type
   DFNLENEI_EXAMINEENAME = 20; // Text type
   DFNLENEI_IP           = 32; // Text type
   DFNLENEI_PORT         = 32; // Text type
   DFNLENEI_STATUS       = 20; // Text type
   DFNLENEI_REMAINTIME   = 24; // Text type
   DFNLENEI_TIMESTAMP    = 20; // Text type
   // DFNLENEI_SCOREINFO   = 'ScoreInfo';     // Ole
   // 以下几个字段是用来保存解密数据的
   DFNLENEI_DECRYPTEDID         = 11;
   DFNLENEI_DECRYPTEDNAME       = 8;
   DFNLENEI_DECRYPTEDSTATUS     = 2;
   DFNLENEI_DECRYPTEDIP         = 15;
   DFNLENEI_DECRYPTEDPORT       = 10;
   DFNLENEI_DECRYPTEDREMAINTIME = 11;
   DFNLENEI_DECRYPTEDTIMESTAMP  = 9;

   {$ENDREGION}
   // ==============================================================================
   // 以下 常量 是公用的 SQL 语句
   // ==============================================================================

   SQLSTR_GETENVIRONMENT_BY_TQ_TYPE = 'select Environment from 试题 where st_no like :v_stno';
   SQLSTR_GETTQID_BY_PREFIX         = 'select st_no from 试题 where st_no like :v_stno';
   SQLSTR_UPDATECLIENTDBREAMINTIME  = 'update 考生信息 set remaintime=:v_remainTime';
   SQLSTR_GETTQDATASET_BY_PREFIX    = 'select * from 试题 where st_no like :v_stno';
   SQLSTR_GETCLIENT_EXAMINEEINFO    = 'select * from 考生信息 where ExamineeID like :v_ExamineeID';
   SQLSTR_GETCLIENT_AllTQ           = 'select * from 试题 ';
   SQLSTR_GETALLEXAMINEES           = 'select ExamineeID,ExamineeName,RemainTime,Status from 考生信息';
   // select 给定试题号的记录
   SQLSTR_GETTQDATASET_BY_STNO = 'select * from 试题 where st_no = :v_stno';

   SQLSTR_SYSCONFIG='select * from sysconfig';

implementation

end.
