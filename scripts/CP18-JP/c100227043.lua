--トポロジック・ガンブラー・ドラゴン
--Topologic Gamble Dragon
function c100227043.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	c:EnableReviveLimit()
	--discard
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100227043,0))
	e1:SetCategory(CATEGORY_HANDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100227043)
	e1:SetCondition(c100227043.hdcon)
	e1:SetTarget(c100227043.hdtg)
	e1:SetOperation(c100227043.hdop)
	c:RegisterEffect(e1)
	--discard
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100227043,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100227043)
	e2:SetCondition(c100227043.hdcon2)
	e2:SetTarget(c100227043.hdtg2)
	e2:SetOperation(c100227043.hdop2)
	c:RegisterEffect(e2)
	if not Card.IsExtraLinked then
		function Duel.GetExtraLinkedGroup(tp)
			local card1=Duel.GetFieldCard(tp,LOCATION_MZONE,1)
			local card2=Duel.GetFieldCard(tp,LOCATION_MZONE,2)
			local card3=Duel.GetFieldCard(tp,LOCATION_MZONE,3)
			local card5=Duel.GetFieldCard(tp,LOCATION_MZONE,5)
			local card6=Duel.GetFieldCard(tp,LOCATION_MZONE,6)
			if not card1 or not card2 or not card3 or not card5 or not card6 then return nil end
			if bit.band(card1:GetMutualLinkedZone(),0x24)~=0x24 then return nil end
			if bit.band(card2:GetMutualLinkedZone(),0xa)~=0xa then return nil end
			if bit.band(card3:GetMutualLinkedZone(),0x44)~=0x44 then return nil end
			if bit.band(card5:GetMutualLinkedZone(),0x2)~=0x2 then return nil end
			if bit.band(card6:GetMutualLinkedZone(),0x8)~=0x8 then return nil end
			local elg=Group:FromCards(card1,card2,card3,card5,card6)
			local card0=Duel.GetFieldCard(tp,LOCATION_MZONE,0)
			local card4=Duel.GetFieldCard(tp,LOCATION_MZONE,4)
			if card0 and bit.band(card0:GetMutualLinkedZone(),0x2)==0x2 then elg:AddCard(card0) end
			if card4 and bit.band(card4:GetMutualLinkedZone(),0x8)==0x8 then elg:AddCard(card4) end
			return elg
		end
		function Card.IsExtraLinked(c)
			local elg=Duel.GetExtraLinkedGroup(c:GetControler())
			return elg and elg:IsContains(c)
		end
	end
end
function c100227043.cfilter(c,zone)
	local seq=c:GetSequence()
	if c:IsControler(1) then seq=seq+16 end
	return bit.extract(zone,seq)~=0
end
function c100227043.hdcon(e,tp,eg,ep,ev,re,r,rp)
	local zone=Duel.GetLinkedZone(0)+Duel.GetLinkedZone(1)*0x10000
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c100227043.cfilter,1,nil,zone)
end
function c100227043.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c100227043.hdop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local ct=math.min(hg:GetCount(),2)
	if ct<=0 then return false end
	local ct2=1
	if ct>1 then ct2=Duel.AnnounceNumber(tp,1,2) end
	local g=hg:RandomSelect(tp,ct2)
	local ct3=Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
	Duel.DiscardHand(1-tp,nil,ct3,ct3,REASON_EFFECT+REASON_DISCARD)
end
function c100227043.hdcon2(e)
	return e:GetHandler():IsExtraLinked()
end
function c100227043.hdtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,2)
end
function c100227043.hdop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(1-tp,nil,2,2,REASON_EFFECT+REASON_DISCARD)~=0
		and Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)==0 then
		Duel.Damage(1-tp,3000,REASON_EFFECT)
	end
end
