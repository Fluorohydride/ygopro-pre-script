--ドットスケーパー
--Dot Scaper
--Scripted by Eerie Code
function c100332007.initial_effect(c)
	--spsummon (banish)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,100332007+EFFECT_COUNT_CODE_DUEL)
	e1:SetCost(c100332007.cost)
	e1:SetTarget(c100332007.target)
	e1:SetOperation(c100332007.operation)
	c:RegisterEffect(e1)
	--spsummon (grave)
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,100332007+EFFECT_COUNT_CODE_DUEL+100)
	c:RegisterEffect(e2)
end
function c100332007.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100332007) end
	Duel.RegisterFlagEffect(tp,100332007,RESET_PHASE+PHASE_END,0,1)
end
function c100332007.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100332007.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
