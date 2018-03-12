--影王デュークシェード
--Duke Shade, King of the Umbra
--Script by nekrozar
function c100306003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100306003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,100306003)
	e1:SetCost(c100306003.spcost)
	e1:SetTarget(c100306003.sptg)
	e1:SetOperation(c100306003.spop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100306003,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,100306103)
	e2:SetCost(c100306003.thcost)
	e2:SetTarget(c100306003.thtg)
	e2:SetOperation(c100306003.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	Duel.AddCustomActivityCounter(100306003,ACTIVITY_SPSUMMON,c100306003.counterfilter)
end
function c100306003.counterfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function c100306003.fselect(c,tp,rg,sg)
	sg:AddCard(c)
	local res=c100306003.fgoal(tp,sg) or rg:IsExists(c100306003.fselect,1,sg,tp,rg,sg)
	sg:RemoveCard(c)
	return res
end
function c100306003.relfilter(c,g)
	return g:IsContains(c)
end
function c100306003.fgoal(tp,sg)
	if sg:GetCount()>0 and Duel.GetMZoneCount(tp,sg)>0 then
		Duel.SetSelectedCard(sg)
		return Duel.CheckReleaseGroup(tp,nil,0,nil)
	else return false end
end
function c100306003.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp):Filter(Card.IsAttribute,nil,ATTRIBUTE_DARK)
	local g=Group.CreateGroup()
	if chk==0 then return Duel.GetCustomActivityCount(100306003,tp,ACTIVITY_SPSUMMON)==0
		and rg:IsExists(c100306003.fselect,1,nil,tp,rg,g) end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100306003.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	while true do
		local mg=rg:Filter(c100306003.fselect,g,tp,rg,g)
		if mg:GetCount()==0 or (c100306003.fgoal(tp,g) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local sg=Duel.SelectReleaseGroup(tp,c100306003.relfilter,1,1,nil,mg)
		g:Merge(sg)
	end
	e:SetLabel(g:GetCount())
	Duel.Release(g,REASON_COST)
end
function c100306003.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end
function c100306003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c100306003.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		local ct=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*500)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c100306003.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(100306003,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c100306003.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c100306003.thfilter(c)
	return c:IsLevelAbove(5) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function c100306003.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c100306003.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c100306003.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c100306003.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c100306003.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
