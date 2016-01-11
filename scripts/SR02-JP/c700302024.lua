--復活の福音
--Gospel of Revival
--Scripted by Eerie Code
function c700302024.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c700302024.target)
	e1:SetOperation(c700302024.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c700302024.reptg)
	e2:SetValue(c700302024.repval)
	e2:SetOperation(c700302024.repop)
	c:RegisterEffect(e2)
end

function c700302024.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c700302024.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and c700302024.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c700302024.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c700302024.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c700302024.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c700302024.repfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c700302024.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c700302024.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(700302024,0))
end
function c700302024.repval(e,c)
	return c700302024.repfilter(c,e:GetHandlerPlayer())
end
function c700302024.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end