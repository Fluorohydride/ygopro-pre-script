--ドカンポリン

--Scripted by nekrozar
function c101010080.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010080.target)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010080,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101010080.thcon)
	e2:SetTarget(c101010080.thtg)
	e2:SetOperation(c101010080.thop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
function c101010080.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0)+Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)
	if Duel.CheckLocation(tp,LOCATION_MZONE,5) and Duel.CheckLocation(1-tp,LOCATION_MZONE,6) then ft=ft+1 end
	if Duel.CheckLocation(tp,LOCATION_MZONE,6) and Duel.CheckLocation(1-tp,LOCATION_MZONE,5) then ft=ft+1 end
	if chk==0 then return ft>0 end
	local seq=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,0)
	e:SetLabel(seq)
end
function c101010080.cfilter(c,seq,tp)
	local nseq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then nseq=nseq+16 end
		return c:IsFaceup() and c:IsType(TYPE_EFFECT) and bit.extract(seq,nseq)~=0
	else
		nseq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1-tp then nseq=nseq+16 end
		return bit.band(c:GetPreviousTypeOnField(),TYPE_EFFECT)~=0 and bit.extract(seq,nseq)~=0
	end
end
function c101010080.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabelObject():GetLabel()
	return eg:IsExists(c101010080.cfilter,1,nil,seq,tp)
end
function c101010080.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local seq=e:GetLabelObject():GetLabel()
	local g=eg:Filter(c101010080.cfilter,nil,seq,tp)
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.SetTargetCard(tg)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c101010080.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	g:AddCard(c)
	if g:GetCount()==2 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
