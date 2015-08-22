unit DataFieldConst;

interface

uses
   Classes;

const
   // ==============================================================================
   // ���³���Ϊ ������ �������ݿ� ���õ� ����
   // ==============================================================================

   TBLNAME_EXAMDB_TQ   = '����';
   TBANAME_EXAMDB_INFO = '������Ϣ';

   // ==============================================================================
   // ���³���Ϊ ϵͳ���  ���ݿ��� ����
   // ==============================================================================

   TBLNAME_TQDB_TQ = '����';

   // ==============================================================================
   // ���³���Ϊ ϵͳ���  �б���Ŀտ������ݿ���ļ�ID
   // ==============================================================================

   CLIENTDB_FILEID = '1';

   // ==============================================================================
   // Ĭ��ϵͳ����ļ���
   // ==============================================================================
   DEFAULTSYSDB_FILENAME = 'ϵͳ���.mdb';
   // ==============================================================================
   // ���³���Ϊ �������ݿ��ļ�Ĭ���ļ���
   // ==============================================================================

   CLIENTDB_FILENAME = '�������.dat';

   // ==============================================================================
   // ������Ϣ���ݿ���
   // ==============================================================================
   GRADEINFO_FILENAME = 'Gradeinfo.mdb';

   // ==============================================================================
   // ���� ����Ϊ ���� �����ֶ���
   // ϵͳ��� �� ������� ���� ���������ֻ�������еĲ���
   // ==============================================================================

   // data field name const for ���� table
   DFNTQ_ST_NO       = 'st_no';
   DFNTQ_CONTENT     = 'Content';
   DFNTQ_ENVIRONMENT = 'Environment';
   DFNTQ_STANSWER    = 'StAnswer';
   DFNTQ_KSDA        = 'ksda';
   DFNTQ_COMMENT     = 'Comment';
   DFNTQ_POINTID     = 'PointID';
   DFNTQ_TIMESTAMP   = 'TimeStamp';
   DFNTQ_DIFFICULTY  = 'Difficulty'; // �����Ѷ�
   DFNTQ_TOTALRIGHT  = 'TotalRight'; // ����ȷ��
   DFNTQ_TOTALUSED   = 'TotalUsed';  // ��ʹ����
   DFNTQ_REDACTTIME  = 'RedactTime'; // �޶�ʱ��
   DFNTQ_REDACTOR    = 'Redactor';   // �޶���
   DFNTQ_ISMODIFIED  = 'IsModified'; // �Ƿ��޸ı��
   // �¿��в������������ֶΣ�ֻΪת���������
   DFNTQ_ST_LR    = 'st_lr';
   DFNTQ_ST_ITEM1 = 'st_item1';
   DFNTQ_ST_ITEM2 = 'st_item2';
   DFNTQ_ST_ITEM3 = 'st_item3';
   DFNTQ_ST_ITEM4 = 'st_item4';
   DFNTQ_ST_DA    = 'st_da';

   DFNTQ_ST_HJ      = 'st_hj';
   DFNTQ_ST_DA1     = 'st_da1';
   DFNTQ_ST_COMMENT = 'st_comment';
   {$REGION '------ ������Ϣ -----'}
   // ==============================================================================
   // ����
   // data field name const for ������Ϣ table
   // ==============================================================================
   // data field name const for ������Ϣ table
   DFNEI_EXAMINEEID   = 'ExamineeID';
   DFNEI_EXAMINEENAME = 'ExamineeName';
   DFNEI_IP           = 'IP';
   DFNEI_PORT         = 'Port';
   DFNEI_STATUS       = 'Status';
   DFNEI_REMAINTIME   = 'RemainTime';
   DFNEI_TIMESTAMP    = 'Stamp';
   DFNEI_SCOREINFO    = 'ScoreInfo';
   DFNEI_SCORE        = 'Score'; // ֻ���ڻ��ܳɼ�����
   // ���¼����ֶ�����������������ݵ�
   DFNEI_DECRYPTEDID         = 'DeCryptedID';
   DFNEI_DECRYPTEDNAME       = 'DeCryptedName';
   DFNEI_DECRYPTEDSTATUS     = 'DeCryptedStatus';
   DFNEI_DECRYPTEDIP         = 'DeCryptedIP';
   DFNEI_DECRYPTEDPORT       = 'DeCryptedPort';
   DFNEI_DECRYPTEDREMAINTIME = 'DeCryptedRemainTime';
   DFNEI_DECRYPTEDTIMESTAMP  = 'DeCryptedTimeStamp';
   // data field length const for ������Ϣ table
   DFNLENEI_EXAMINEEID   = 24; // Text type
   DFNLENEI_EXAMINEENAME = 20; // Text type
   DFNLENEI_IP           = 32; // Text type
   DFNLENEI_PORT         = 32; // Text type
   DFNLENEI_STATUS       = 20; // Text type
   DFNLENEI_REMAINTIME   = 24; // Text type
   DFNLENEI_TIMESTAMP    = 20; // Text type
   // DFNLENEI_SCOREINFO   = 'ScoreInfo';     // Ole
   // ���¼����ֶ�����������������ݵ�
   DFNLENEI_DECRYPTEDID         = 11;
   DFNLENEI_DECRYPTEDNAME       = 8;
   DFNLENEI_DECRYPTEDSTATUS     = 2;
   DFNLENEI_DECRYPTEDIP         = 15;
   DFNLENEI_DECRYPTEDPORT       = 10;
   DFNLENEI_DECRYPTEDREMAINTIME = 11;
   DFNLENEI_DECRYPTEDTIMESTAMP  = 9;

   {$ENDREGION}
   // ==============================================================================
   // ���� ���� �ǹ��õ� SQL ���
   // ==============================================================================

   SQLSTR_GETENVIRONMENT_BY_TQ_TYPE = 'select Environment from ���� where st_no like :v_stno';
   SQLSTR_GETTQID_BY_PREFIX         = 'select st_no from ���� where st_no like :v_stno';
   SQLSTR_UPDATECLIENTDBREAMINTIME  = 'update ������Ϣ set remaintime=:v_remainTime';
   SQLSTR_GETTQDATASET_BY_PREFIX    = 'select * from ���� where st_no like :v_stno';
   SQLSTR_GETCLIENT_EXAMINEEINFO    = 'select * from ������Ϣ where ExamineeID like :v_ExamineeID';
   SQLSTR_GETCLIENT_AllTQ           = 'select * from ���� ';
   SQLSTR_GETALLEXAMINEES           = 'select ExamineeID,ExamineeName,RemainTime,Status from ������Ϣ';
   // select ��������ŵļ�¼
   SQLSTR_GETTQDATASET_BY_STNO = 'select * from ���� where st_no = :v_stno';

   SQLSTR_SYSCONFIG='select * from sysconfig';

implementation

end.
