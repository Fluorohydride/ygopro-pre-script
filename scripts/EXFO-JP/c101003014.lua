--蒼穹の機界騎士
--Mekk-Knight of the Blue Sky
--Scripted by Eerie Code
function c101003014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101003014)
	e1:SetCondition(c101003014.hspcon)
	e1:SetValue(c101003014.hspval)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101003014,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,101003014+100)
	e2:SetTarget(c101003014.thtg)
	e2:SetOperation(c101003014.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c101003014.thcon)
	c:RegisterEffect(e3)
end
function c101003014.cfilter(c,tp,seq)
	local s=c:GetSequence()
	if c:IsLocation(LOCATION_SZONE) and s==5 then return false end
	if c:IsControler(tp) then
		return s==seq or (seq==1 and s==5) or (seq==3 and s==6)
	else
		return s==4-seq or (seq==1 and s==6) or (seq==3 and s==5)
	end
end
function c101003014.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	for i=0,4 do
		if Duel.GetMatchingGroupCount(c101003014.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)>=2 then
			zone=zone+math.pow(2,i)
		end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003014.hspval(e,c)
	local tp=c:GetControler()
	local zone=0
	for i=0,4 do
		if Duel.GetMatchingGroupCount(c101003014.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,i)>=2 then
			zone=zone+math.pow(2,i)
		end
	end
	return 0,zone
end
function c101003014.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_HAND)
end
function c101003014.thfilter(c)
	return c:IsSetCard(0x20c) and c:IsType(TYPE_MONSTER) and not c:IsCode(101003014) and c:IsAbleToHand()
end
function c101003014.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101003014.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=e:GetHandler():GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)
	if chk==0 then return ct>0 and g:GetClassCount(Card.GetCode)>=ct end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,ct,tp,LOCATION_DECK)
end
function c101003014.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c101003014.thfilter,tp,LOCATION_DECK,0,nil)
	local ct=e:GetHandler():GetColumnGroup():FilterCount(Card.IsControler,nil,1-tp)
	if ct<=0 or g:GetClassCount(Card.GetCode)<ct then return end
	local hg=Group.CreateGroup()
	for i=1,ct do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		hg:AddCard(tc)
		g:Remove(Card.IsCode,nil,tc:GetCode())
	end
	Duel.SendtoHand(hg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,hg)
end
