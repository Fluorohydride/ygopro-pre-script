--The despair URANUS
--Script by nekrozar
function c100206009.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100206009,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c100206009.setcon)
	e1:SetTarget(c100206009.settg)
	e1:SetOperation(c100206009.setop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c100206009.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c100206009.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c100206009.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_ADVANCE
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c100206009.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c100206009.setfilter(c,typ)
	return c:GetType()==typ and c:IsSSetable()
end
function c100206009.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,555)
	local op=Duel.SelectOption(1-tp,71,72)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=nil
	if op==0 then g=Duel.SelectMatchingCard(tp,c100206009.setfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL+TYPE_CONTINUOUS)
	else g=Duel.SelectMatchingCard(tp,c100206009.setfilter,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP+TYPE_CONTINUOUS) end
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c100206009.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c100206009.atkval(e,c)
	return Duel.GetMatchingGroupCount(c100206009.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*300
end
function c100206009.indtg(e,c)
	return c:GetSequence()<5 and c:IsFaceup()
end
