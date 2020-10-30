--炼装勇士·消灭
function c101103021.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--destroy and set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101103021,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101103021.target)
	e1:SetOperation(c101103021.operation)
	c:RegisterEffect(e1) 
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101103021,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,101103021)
	e2:SetTarget(c101103021.sptg)
	e2:SetOperation(c101103021.spop)
	c:RegisterEffect(e2)  
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101103121)
	e3:SetCondition(c101103021.rmcon)
	e3:SetTarget(c101103021.rmtg)
	e3:SetOperation(c101103021.rmop)
	c:RegisterEffect(e3) 
end
function c101103021.desfilter(c,tp)
	if c:IsFacedown() then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft==0 and c:IsLocation(LOCATION_SZONE) and c:GetSequence()<5 then
		return Duel.IsExistingMatchingCard(c101103021.filter,tp,LOCATION_DECK,0,1,nil,true)
	else
		return Duel.IsExistingMatchingCard(c101103021.filter,tp,LOCATION_DECK,0,1,nil,false)
	end
end
function c101103021.filter(c,ignore)
	return c:IsSetCard(0xe1) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(ignore)
end
function c101103021.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and c101103021.desfilter(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c101103021.desfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler(),tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101103021.desfilter,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler(),tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101103021.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c101103021.filter,tp,LOCATION_DECK,0,1,1,nil,false)
		if g:GetCount()>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end
function c101103021.spfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0xe1) and Duel.IsExistingTarget(c101103021.spfilter2,tp,LOCATION_ONFIELD,0,1,c)
end
function c101103021.spfilter2(c)
	return c:IsFaceup()
end
function c101103021.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>1
		and Duel.IsExistingTarget(c101103021.spfilter1,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(101103021,3))
	local g1=Duel.SelectTarget(tp,c101103021.spfilter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c101103021.spfilter2,tp,LOCATION_ONFIELD,0,1,1,g1,e,tp)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101103021.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.Destroy(g,REASON_EFFECT)~=0 then
		local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c101103021.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler():IsSetCard(0xe1)
end
function c101103021.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function c101103021.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return (chkc:IsLocation(LOCATION_MZONE) or chkc:IsLocation(LOCATION_GRAVE)) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(c101103021.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c101103021.rmfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c101103021.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end