--V－LAN ヒドラ
--V-LAN Hydra
--Script by nekrozar
function c100200133.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c100200133.matfilter,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100200133.atkval)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100200133,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,100200133)
	e2:SetTarget(c100200133.tktg)
	e2:SetOperation(c100200133.tkop)
	c:RegisterEffect(e2)
end
function c100200133.matfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c100200133.cfilter(c,mc)
	local lg=c:GetLinkedGroup()
	return lg and lg:IsContains(mc)
end
function c100200133.atkval(e,c)
	return c:GetLinkedGroup():FilterCount(c100200133.cfilter,nil,c)*300
end
function c100200133.rfilter(c,tp,g)
	local lk=c:GetLink()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return c:IsFaceup() and c:IsType(TYPE_LINK) and lk<4 and c:IsReleasableByEffect() and g:IsContains(c)
		and ft>=lk and (ft==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
end
function c100200133.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup():Filter(c100200133.cfilter,nil,c)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c100200133.rfilter(chkc,tp,lg) end
	if chk==0 then return Duel.IsExistingTarget(c100200133.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,lg)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,100201133,0,0x4011,0,0,1,RACE_CYBERS,ATTRIBUTE_LIGHT) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectTarget(tp,c100200133.rfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,lg)
	local ct=rg:GetFirst():GetLink()
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ct,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,0,0)
end
function c100200133.tkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ct=tc:GetLink()
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and Duel.Release(tc,REASON_EFFECT)>0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<ct or (ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
		if not Duel.IsPlayerCanSpecialSummonMonster(tp,100201133,0,0x4011,0,0,1,RACE_CYBERS,ATTRIBUTE_LIGHT) then return end
		for i=1,ct do
			local token=Duel.CreateToken(tp,100201133)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetLabel(ct)
	e1:SetTarget(c100200133.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c100200133.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:GetLink()==e:GetLabel()
end
