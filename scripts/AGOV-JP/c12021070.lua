--睨统之蛇眼龙
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	-- e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	
end

function s.confilter(c,e,tp)
	return c:IsSetCard(0xf03) and c:IsType(TYPE_MONSTER)
end
function s.mfilter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function s.sfilter(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_CONTINUOUS) and c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.condition(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(s.confilter,tp,LOCATION_MZONE,0,nil,e,tp)
    local levels=0
    local tc=g:GetFirst()
    while gc do
        levels=levels+tc:GetLevel() 
        tc=g:GetNext()
    end
	if levels<2 then return false else return true end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.mfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,nil,e,tp)
	local b2=Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil,e,tp)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(id,0))
	else op=Duel.SelectOption(tp,aux.Stringid(id,1))+1 end
	e:SetLabel(op)
	if op==0 then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
        Duel.SelectTarget(tp,s.mfilter,tp,0,LOCATION_MZONE+LOCATION_GRAVE,1,1,nil,e,tp)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_SZONE)
        Duel.SelectTarget(tp,s.sfilter,tp,LOCATION_SZONE,LOCATION_SZONE,1,1,nil,e,tp)
	end
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e)
			and Duel.MoveToField(tc,tp,tc:GetOwner(),LOCATION_SZONE,POS_FACEUP,true) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	else
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end