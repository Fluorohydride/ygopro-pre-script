--デメット爺さん
--Grandpa Demetto
--LUA by Kohana Sonogami
function c100273016.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Special Summon up to 2 Normal Monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100273016,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,100273016)
	e1:SetCost(c100273016.spcost)
	e1:SetTarget(c100273016.sptg)
	e1:SetOperation(c100273016.spop)
	c:RegisterEffect(e1)
	--Destroy and inflict 300 damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100273016,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCountLimit(1,100273016+100)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100273016.descon)
	e2:SetTarget(c100273016.destg)
	e2:SetOperation(c100273016.desop)
	c:RegisterEffect(e2)
	if not c100273016.global_check then
		c100273016.global_check=true
		c100273016[0]=nil
		c100273016[1]=Group.CreateGroup()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DETACH_MATERIAL)
		ge1:SetOperation(c100273016.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EFFECT_OVERLAY_REMOVE_REPLACE)
		ge2:SetLabelObject(ge1)
		ge2:SetCondition(c100273016.rcon)
		Duel.RegisterEffect(ge2,0)
	end
end
function c100273016.defilter(c,tp)
	return c:IsFaceup() and c:IsCode(75574498) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c100273016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100273016.defilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local c=Duel.SelectMatchingCard(tp,c100273016.defilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100273016.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and (c:IsAttack(0)) or (c:IsDefense(0)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100273016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100273016.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_GRAVE)
end
function c100273016.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100273016.spfilter,tp,LOCATION_GRAVE,0,1,ft,nil,e,tp)
	local tc=g:GetFirst() 
	while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(8)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e2:SetValue(ATTRIBUTE_DARK)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
end
function c100273016.rcon(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabelObject(re:GetHandler():GetOverlayGroup())
	return false
end
function c100273016.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 and e:GetLabelObject() then 
		c100273016[0]=Duel.GetChainInfo(cid,CHAININFO_CHAIN_ID)
		c100273016[1]=e:GetLabelObject()-eg:GetFirst():GetOverlayGroup()
		c100273016[1]:KeepAlive()
	end
end
function c100273016.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==c100273016[0]
		and re:GetHandler():IsCanBeEffectTarget(e) and re:GetHandler():IsControler(tp)
		and re:IsActiveType(TYPE_XYZ) and c100273016[1] and c100273016[1]:IsExists(Card.IsType,1,nil,TYPE_NORMAL)
end
function c100273016.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetTargetCard(re:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c100273016.desop(e,tp,eg,ep,ev,re,r,rp)
	local ex,g=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	if g:GetFirst():IsRelateToEffect(e) then
		if Duel.Destroy(g,REASON_EFFECT)~=0 then
			local tc=g:GetFirst()
			local dam=tc:GetRank()*300
			Duel.Damage(1-tp,dam,REASON_EFFECT)
		end
	end
end
