--梦鲨
function c100290025.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100290025,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100290025)
	e1:SetCondition(c100290025.spcon)
	e1:SetTarget(c100290025.sptg)
	e1:SetOperation(c100290025.spop)
	c:RegisterEffect(e1)
	--battle indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c100290025.valcon)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100290025,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,100290125)
	e3:SetCondition(aux.damcon1)
	e3:SetTarget(c100290025.sptg2)
	e3:SetOperation(c100290025.spop2)
	c:RegisterEffect(e3)
end
function c100290025.cfilter(c)
	return c:IsFacedown() or not c:IsAttribute(ATTRIBUTE_WATER)
end
function c100290025.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c100290025.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100290025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100290025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c100290025.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and c:GetFlagEffect(100290025)==0 end
	c:RegisterFlagEffect(100290025,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100290025.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabel(cid)
		e1:SetValue(c100290025.damval)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e2:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(-1000)
		c:RegisterEffect(e3)
	end
end
function c100290025.damval(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return val end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid~=e:GetLabel() then return val end
	return 0
end