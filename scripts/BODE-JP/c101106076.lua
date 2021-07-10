--ブレイク・ザ・デステニー
--
--Script by mercury233
function c101106076.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101106076,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e1:SetCountLimit(1,101106076)
	e1:SetTarget(c101106076.destg)
	e1:SetOperation(c101106076.desop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101106076,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,101106076)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c101106076.thtg)
	e2:SetOperation(c101106076.thop)
	c:RegisterEffect(e2)
end
if Auxiliary.AddSetNameMonsterList==nil then
	function Auxiliary.AddSetNameMonsterList(c,...)
		if c:IsStatus(STATUS_COPYING_EFFECT) then return end
		if c.setcode_monster_list==nil then
			local mt=getmetatable(c)
			mt.setcode_monster_list={}
			for i,scode in ipairs{...} do
				mt.setcode_monster_list[i]=scode
			end
		else
			for i,scode in ipairs{...} do
				c.setcode_monster_list[i]=scode
			end
		end
	end
	function Auxiliary.IsSetNameMonsterListed(c,setcode)
		if not c.setcode_monster_list then return false end
		for i,scode in ipairs(c.setcode_monster_list) do
			if setcode&0xfff==scode&0xfff and setcode&scode==setcode then return true end
		end
		return false
	end
end
function c101106076.desfilter(c)
	return c:IsFaceup() and (c:IsCode(76263644) or c:IsSetCard(0xc008) and c:IsLevelAbove(8))
end
function c101106076.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101106076.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101106076.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101106076.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101106076.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SKIP_M1)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		if Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_MAIN1 then
			e1:SetLabel(Duel.GetTurnCount())
			e1:SetCondition(c101106076.turncon)
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
		else
			e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		end
		Duel.RegisterEffect(e1,tp)
	end
end
function c101106076.turncon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c101106076.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand() and not c:IsCode(101106076)
		and (aux.IsCodeListed(c,76263644) or aux.IsSetNameMonsterListed(c,0xc008))
end
function c101106076.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101106076.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c101106076.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c101106076.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
