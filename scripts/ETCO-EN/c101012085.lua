--Bluebeard, the Plunder Patroll Shipwright
--
--Script by JoyJ
function c101012085.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101012085,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101012085)
	e1:SetCondition(c101012085.spcon)
	e1:SetTarget(c101012085.sptg)
	e1:SetOperation(c101012085.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101012085,1))
	e2:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,101012085+100)
	e2:SetCondition(c101012085.drcon)
	e2:SetTarget(c101012085.drtg)
	e2:SetOperation(c101012085.drop)
	c:RegisterEffect(e2)
end
function c101012085.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x13f) and not c:IsCode(101012085)
end
function c101012085.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101012085.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101012085.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101012085.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c101012085.drcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) or c:IsPreviousLocation(LOCATION_HAND)
end
function c101012085.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101012085.drop(e,tp,eg,ep,ev,re,r,rp)
	local _,__,p,d=Duel.GetOperationInfo(0,CATEGORY_HANDES)
	local ___,____,p2,d2=Duel.GetOperationInfo(0,CATEGORY_DRAW)
	Duel.DiscardHand(p,nil,d,d,REASON_EFFECT+REASON_DISCARD,nil)
	Duel.Draw(p2,d2,REASON_EFFECT)
end
