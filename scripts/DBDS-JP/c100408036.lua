--閃刀機－シャークキャノン
--Brandish Mecha Shark Cannon
--Scripted by ahtelel
function c100408036.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c100408036.condition)
	e1:SetTarget(c100408036.target)
	e1:SetOperation(c100408036.activate)
	c:RegisterEffect(e1)
end
function c100408036.cfilter(c)
	return c:GetSequence()<5
end
function c100408036.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100408036.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100408036.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c100408036.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE) and c100408036.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100408036.filter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=Duel.SelectTarget(tp,c100408036.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	local op=0
	if Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,3,nil,TYPE_SPELL) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and g:GetFirst():IsCanBeSpecialSummoned(e,0,tp,false,false) then
		op=Duel.SelectOption(tp,aux.Stringid(100408036,0),aux.Stringid(100408036,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(100408036,0))
	end
	e:SetLabel(op)
	if op==0 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	elseif op==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
end
function c100408036.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and e:GetLabel()==0 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)	   
	elseif tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and e:GetLabel()==1 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1,true)
	end
end