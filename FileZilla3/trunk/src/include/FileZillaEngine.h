#ifndef __FILEZILLAENGINE_H__
#define __FILEZILLAENGINE_H__

enum EngineNotificationType
{
	engineCancel,
	engineHostresolve,
	engineTransferEnd
};

class CControlSocket;
class CAsyncHostResolver;
class wxFzEngineEvent;
class CFileZillaEngine : protected wxEvtHandler
{
	friend class CControlSocket;
	friend class CFtpControlSocket;
	friend class CAsyncHostResolver;
	friend class CTransferSocket; // Only calls SendEvent(engineTransferEnd) and SetActive
public:
	CFileZillaEngine();
	virtual ~CFileZillaEngine();

	int Init(wxEvtHandler *pEventHandler, COptionsBase *pOptions);

	int Command(const CCommand &command);

	bool IsBusy() const;
	bool IsConnected() const;
	
	bool IsActive(bool recv); // Return true only if data has been transferred or sent since the last check

	void AddNotification(CNotification *pNotification);
	CNotification *GetNextNotification();

	const CCommand *GetCurrentCommand() const;
	enum Command GetCurrentCommandId() const;

	COptionsBase *GetOptions() const;

	bool SetAsyncRequestReply(CAsyncRequestNotification *pNotification);
	int GetNextAsyncRequestNumber();

	bool GetTransferStatus(CTransferStatus &status, bool &changed);

	// Resend all modified directory listings if they are available in the cache.
	// This function affects all engines.
	void ResendModifiedListings();

protected:
	bool SendEvent(enum EngineNotificationType eventType, int data = 0);
	void OnEngineEvent(wxFzEngineEvent &event);

	int Connect(const CConnectCommand &command);
	int Disconnect(const CDisconnectCommand &command);
	int Cancel(const CCancelCommand &command);
	int List(const CListCommand &command);
	int FileTransfer(const CFileTransferCommand &command);
	int RawCommand(const CRawCommand& command);
	int Delete(const CDeleteCommand& command);
	int RemoveDir(const CRemoveDirCommand& command);
	int Mkdir(const CMkdirCommand& command);
	int Rename(const CRenameCommand& command);
	int Chmod(const CChmodCommand& command);

	int ResetOperation(int nErrorCode);
	
	void SetActive(bool recv);

	wxEvtHandler *m_pEventHandler;
	CControlSocket *m_pControlSocket;

	CCommand *m_pCurrentCommand;

	std::list<CNotification *> m_NotificationList;
	std::list<CAsyncHostResolver *> m_HostResolverThreads;

	bool m_bIsInCommand; //true if Command is on the callstack
	int m_nControlSocketError;

	COptionsBase *m_pOptions;

	unsigned int m_asyncRequestCounter; // Initialized to random value, increased by one on each request

	// Indicicates if data has been received/sent and whether to send any notifications
	static int m_activeStatusSend;
	static int m_activeStatusRecv;

	// Remember last path used in a dirlisting.
	CServerPath m_lastListDir;
	CTimeEx m_lastListTime;

	static std::list<CFileZillaEngine*> m_engineList;

	DECLARE_EVENT_TABLE();
};

#endif
