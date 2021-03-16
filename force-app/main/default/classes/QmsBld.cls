public class QmsBld {

	public static QmsBuilder newRoot(){
		String theNodeId = GuidUtil.NewGuid();
		return new QmsBuilder().setChainNodeType('Root').setChainNodeId( theNodeId ) 
			.setChainRootId(theNodeId).setChainParentId(null).setChainDepth(0);
	}
	public static QmsBuilder newChild(Qms__c pParent){
		return new QmsBuilder().setChainNodeType('Child').setChainNodeId( GuidUtil.NewGuid() ) 
			.setChainRootId( pParent.ChainRootId__c )
			.setChainParentId(pParent.ChainNodeId__c)
			.setChainDepth( (Integer)pParent.ChainDepth__c + 1 );
	}
	public class QmsBuilder{
		private String msgType = null;
		private String data = null;
		private String dispatchStatus = 'Created';
		private String shoriStatus = 'Created';
		private DateTime scheduledAt = null;
		private String chainNodeId = null;
		private String chainNodeType = null;
		private String chainParentId = null;
		private String chainRootId = null;
		private Integer chainDepth = 0;
		public QmsBuilder setMsgType(String pValue){ this.msgType = pValue; return this; }
		public QmsBuilder setData(String pValue){ this.data = pValue; return this; }
		public QmsBuilder setScheduledAt(Datetime pValue){ this.scheduledAt = pValue; return this; }
		private QmsBuilder setChainNodeId(String pValue){ this.chainNodeId = pValue; return this; }
		private QmsBuilder setChainNodeType(String pValue){ this.chainNodeType = pValue; return this; }
		private QmsBuilder setChainParentId(String pValue){ this.chainParentId = pValue; return this; }
		private QmsBuilder setChainRootId(String pValue){ this.chainRootId = pValue; return this; }
		private QmsBuilder setChainDepth(Integer pValue){ this.chainDepth = pValue; return this; }
		public Qms__c build(){
			return new Qms__c(
				MsgType__c = this.msgType, Data__c = this.data,
				DispatchStatus__c = this.dispatchStatus,
				ShoriStatus__c = this.shoriStatus,
				ScheduledAt__c = this.scheduledAt,
				ChainNodeId__c = this.chainNodeId,
				ChainNodeType__c = this.chainNodeType,
				ChainParentId__c = this.chainParentId,
				ChainRootId__c = this.chainRootId,
				ChainDepth__c = this.chainDepth
			);
		}
	}
}