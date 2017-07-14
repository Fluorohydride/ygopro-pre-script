--影六武衆－ハツメ
--Shadow Six Samurai – Hatsume
--Scripted by Eerie Code
function c100419003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100419003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,100419003)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c100419003.cost)
	e1:SetTarget(c100419003.target)
	e1:SetOperation(c100419003.operation)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c100419003.reptg)
	e2:SetValue(c100419003.repval)
	e2:SetOperation(c100419003.repop)
	c:RegisterEffect(e2)
end
function c100419003.filter0(c)
	return c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c100419003.filter1(c)
	return c:IsSetCard(0x3d) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function c100419003.filter3(c,e,tp)
	return c100419003.filter1(c)
		and Duel.IsExistingMatchingCard(c100419003.filter4,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,c,e,tp,c)
end
function c100419003.filter4(c,e,tp,rc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local g=Group.FromCards(c,rc)
	local ct=g:FilterCount(c100419003.filter0,nil)
	return c100419003.filter1(c) and ft+ct>0
		and Duel.IsExistingTarget(c100419003.filter2,tp,LOCATION_GRAVE,0,1,g,e,tp)
end
function c100419003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100419003.filter3,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c100419003.filter3,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c100419003.filter4,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst())
	g1:Merge(g2)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
function c100419003.filter2(c,e,tp)
	return c:IsSetCard(0x3d) and not c:IsCode(100419003) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100419003.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100419003.filter2(chkc,e,tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c100419003.filter2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c100419003.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100419003.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x3d)
		and c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsReason(REASON_EFFECT)
end
function c100419003.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c100419003.repfilter,1,nil,tp)
		and eg:GetCount()==1 end
	return Duel.SelectYesNo(tp,aux.Stringid(100419003,1))
end
function c100419003.repval(e,c)
	return c100419003.repfilter(c,e:GetHandlerPlayer())
end
function c100419003.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
