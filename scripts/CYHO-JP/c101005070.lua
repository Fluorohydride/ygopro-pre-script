--リンク・デス・ターレット
--Link Turret
--Scripted by Eerie Code
function c101005070.initial_effect(c)
	c:EnableCounterPermit(0x48)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101005070.target)
	e1:SetOperation(c101005070.activate)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c101005070.ctcon)
	e2:SetOperation(c101005070.ctop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c101005070.spcon)
	e3:SetCost(c101005070.spcost)
	e3:SetTarget(c101005070.sptg)
	e3:SetOperation(c101005070.spop)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(101005070,ACTIVITY_SPSUMMON,c101005070.counterfilter)
end
function c101005070.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c101005070.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsCanAddCounter(tp,0x48,4,c) end
	if c101005070.spcon(e,tp,eg,ep,ev,re,r,rp) and c101005070.spcost(e,tp,eg,ep,ev,re,r,rp,0)
		and c101005070.sptg(e,tp,eg,ep,ev,re,r,rp,0) and Duel.SelectYesNo(tp,aux.Stringid(101005070,0)) then
			e:SetCategory(CATEGORY_COUNTER+CATEGORY_SPECIAL_SUMMON)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			e:SetOperation(c101005070.spop)
			c101005070.spcost(e,tp,eg,ep,ev,re,r,rp,1)
			c101005070.sptg(e,tp,eg,ep,ev,re,r,rp,1)
		end
end
function c101005070.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		c:AddCounter(0x48,4)
	end
end
function c101005070.counterfilter(c)
	return c:GetSummonLocation()~=LOCATION_EXTRA or (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_DARK))
end
function c101005070.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and r&REASON_BATTLE~=0
end
function c101005070.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x48,1)
end
function c101005070.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c101005070.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x48,1,REASON_EFFECT)
		and Duel.GetCustomActivityCount(101005070,tp,ACTIVITY_SPSUMMON)==0 end
	e:GetHandler():RemoveCounter(tp,0x48,1,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c101005070.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c101005070.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_LINK) and c:IsAttribute(ATTRIBUTE_DARK)) and c:IsLocation(LOCATION_EXTRA)
end
function c101005070.spfilter(c,e,tp)
	return c:IsSetCard(0x102) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101005070.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c101005070.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c101005070.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c101005070.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c101005070.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) 
		and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0xfe0000)
		tc:RegisterEffect(e2,true)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetReset(RESET_EVENT+0x47e0000)
		e3:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e3,true)
	end
end
