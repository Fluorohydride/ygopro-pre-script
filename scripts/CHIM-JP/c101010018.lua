--芳香法师-墨角兰
function c101010018.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010018,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101010018)
	e1:SetCondition(c101010018.spcon)
	e1:SetTarget(c101010018.sptg)
	e1:SetOperation(c101010018.spop)
	c:RegisterEffect(e1)
	--Avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c101010018.abdfilter)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--remove grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(101010018,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,101010018+100)
	e3:SetCondition(c101010018.rgcon)
	e3:SetTarget(c101010018.rgtg)
	e3:SetOperation(c101010018.rgop)
	c:RegisterEffect(e3)
end
function c101010018.cfilter(c)
	return c:GetPreviousControler()==tp and c:GetPreviousRaceOnField()&RACE_PLANT~=0
end
function c101010018.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c101010018.cfilter,1,nil,tp)
end
function c101010018.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c101010018.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) > 0 then
		Duel.BreakEffect()
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
function c101010018.abdfilter(e,c)
	local tp = c:GetControler()
	return Duel.GetLP(tp) > Duel.GetLP(1-tp) and c:IsRace(RACE_PLANT)
end
function c101010018.rgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c101010018.rgfilter(c)
	return c:IsSetCard(0xc9) and c:IsFaceup()
end
function c101010018.rgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local i = Duel.GetMatchingGroupCount(c101010018.rgfilter,tp,LOCATION_MZONE,0,nil)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_GRAVE)
		and chkc:IsAbleToRemove() end
	if chk==0 then return i>0 and Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,i,nil)
end
function c101010018.rgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
