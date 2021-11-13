--七皇昇格
--
--Script by Trishula9
function c100426006.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100426006,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,100426006)
	e1:SetTarget(c100426006.target)
	e1:SetOperation(c100426006.operation)
	c:RegisterEffect(e1)
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100426006,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,100426006+100)
	e2:SetCondition(c100426006.cpcon)
	e2:SetCost(c100426006.cpcost)
	e2:SetTarget(c100426006.cptg)
	e2:SetOperation(c100426006.cpop)
	c:RegisterEffect(e2)
end
function c100426006.filter(c)
	return (not c:IsCode(100426006) and c:IsSetCard(0x277) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x278) and c:IsType(TYPE_SPELL+TYPE_TRAP))
		or (c:IsSetCard(0x95) and c:IsType(TYPE_QUICKPLAY))
end
function c100426006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100426006.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c100426006.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c100426006.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and Duel.SelectOption(tp,1190,aux.Stringid(100426006,0))==0 then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.ShuffleDeck(tp)
			Duel.MoveSequence(tc,0)
			Duel.ConfirmDecktop(tp,1)
		end
	end
end
function c100426006.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c100426006.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100426006.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c100426006.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c100426006.cpfilter(c)
	return c:GetType()&TYPE_SPELL==TYPE_SPELL and c:IsSetCard(0x95) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function c100426006.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c100426006.cpfilter,tp,LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c100426006.cpfilter,tp,LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c100426006.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
